//
//  SerialDeviceView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/13/23.
//

#if os(macOS)
import Foundation
import SwiftUI
import Swarm
import SFSafeSymbols

struct SerialDeviceView: View {
    
    @EnvironmentObject
    private var store: Store
    
    let path: String
    
    @State
    private var device: SerialDevice?
    
    @State
    private var messages: [Message] = []
    
    @State
    private var error: String?
    
    @State
    private var readTask: Task<Void, Never>?
    
    @State
    private var sendTask: Task<Void, Never>?
    
    @State
    private var sendMessageBody: String = ""
    
    @State
    private var sendMessageType: String = ""
    
    @State
    private var isPinned = true
    
    private let messageLimit = 500
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                Table(messages, columns: {
                    
                    // Date
                    TableColumn("Date") { message in
                        Text(verbatim: message.date.formatted(date: .omitted, time: .standard))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .tag(message.id)
                    }
                    .width(min: 80, ideal: 100, max: 120)
                    
                    // Type
                    TableColumn("Type") { message in
                        if let serialMessage = SerialMessage(rawValue: message.contents) {
                            Text(verbatim: serialMessage.type.rawValue)
                                .tag(message.id)
                        } else {
                            EmptyView()
                        }
                    }
                    .width(min: 80, ideal: 100, max: 120)
                    
                    // Message
                    TableColumn("Message") { message in
                        Text(verbatim: SerialMessage(rawValue: message.contents)?.body ?? message.contents)
                            .tag(message.id)
                    }
                })
                .onChange(of: messages) { newValue in
                    if isPinned, let message = newValue.last {
                        scrollView.scrollTo(message.id)
                    }
                }
            }
            HStack {
                TextField("Message Type", text: $sendMessageType)
                    .frame(width: 120)
                TextField("Type message", text: $sendMessageBody)
                Button("Send") {
                    send()
                }
                .disabled(!canSend)
            }
            .padding(.all)
        }
        .navigationTitle("Serial")
        .toolbar {
            pinButton
        }
        .task {
            await loadDevice()
        }
        .alert("Error", isPresented: showError, actions: {
            Button("OK") {
                self.error = nil
            }
        }, message: {
            Text(verbatim: self.error ?? "")
        })
    }
}

private extension SerialDeviceView {
    
    func loadDevice() async {
        guard self.device == nil || self.error != nil else {
            return
        }
        self.messages.removeAll(keepingCapacity: true)
        self.error = nil
        self.readTask?.cancel()
        self.readTask = nil
        do {
            self.device = try await SerialDevice(path: path)
        }
        catch {
            store.log("Unable to load serial device at \(path). \(error)")
            self.error = error.localizedDescription
        }
        self.readTask = Task(priority: .utility) {
            do {
                while let device = self.device {
                    let line = try await device.recieve()
                    guard line.isEmpty == false else {
                        continue
                    }
                    let message = Message(contents: line)
                    insert(message)
                }
            }
            catch {
                store.log("Unable to read message. \(error)")
                self.error = error.localizedDescription
            }
        }
    }
    
    func send() {
        guard let device = self.device else {
            assertionFailure("Device not loaded")
            return
        }
        assert(self.sendTask == nil)
        let type = SerialMessageType(rawValue: sendMessageType)
        let messageBody = sendMessageBody.isEmpty ? nil : sendMessageBody
        let serialMessage = SerialMessage(type: type, body: messageBody)
        self.sendTask = Task(priority: .userInitiated) {
            defer { self.sendTask = nil }
            do {
                try await device.send(serialMessage)
                let message = Message(contents: serialMessage.rawValue)
                insert(message)
            }
            catch {
                store.log("Unable to send message. \(error)")
                self.error = error.localizedDescription
            }
        }
    }
    
    func insert(_ message: Message) {
        // insert
        messages.append(message)
        // limit at 200 messages
        if messages.count > messageLimit {
            _ = messages.dropLast(messages.count - messageLimit)
        }
        // sort
        messages.sort(by: { $0.date < $1.date })
    }
    
    func row(for message: Message) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: nil) {
            Text(verbatim: message.date.formatted(date: .omitted, time: .standard))
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(verbatim: message.contents)
        }
    }
    
    var showError: Binding<Bool> {
        Binding(get: {
            self.error != nil
        }, set: {
            if $0 == false {
                self.error = nil
            }
        })
    }
    
    var canSend: Bool {
        sendMessageType.isEmpty == false &&
        sendMessageBody.isEmpty == false &&
        sendTask == nil &&
        device != nil
    }
    
    var pinButton: some View {
        Button(action: {
            isPinned.toggle()
        }, label: {
            if isPinned {
                Image(systemSymbol: .arrowUpLeftCircleFill)
                    .foregroundColor(.accentColor)
            } else {
                Image(systemSymbol: .arrowUpLeftCircle)
            }
        })
    }
}

// MARK: - Supporting Types

extension SerialDeviceView {
    
    struct Message: Equatable, Hashable {
        
        let date = Date()
        
        let contents: String
    }
}

extension SerialDeviceView.Message: Identifiable {
    
    var id: Double {
        date.timeIntervalSinceReferenceDate
    }
}
#endif
