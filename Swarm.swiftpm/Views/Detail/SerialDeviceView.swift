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
    private var sendMessage: String = ""
    
    private let messageLimit = 200
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: nil) {
                        ForEach(messages) { message in
                            row(for: message)
                        }
                    }
                    .padding(.horizontal, nil)
                }
                .onChange(of: messages) { newValue in
                    if let message = newValue.last {
                        scrollView.scrollTo(message.id)
                    }
                }
            }
            HStack {
                TextField("Type message", text: $sendMessage)
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
        //let message = Message(contents: )
    }
    
    func insert(_ message: Message) {
        messages.append(message)
        if messages.count > messageLimit {
            _ = messages.dropLast(messages.count - messageLimit)
        }
    }
    
    func row(for message: Message) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: nil) {
            Text(verbatim: message.date.formatted(date: .omitted, time: .standard))
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(verbatim: message.contents)
        }
        .tag(message.id)
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
        sendMessage.isEmpty == false
    }
    
    var pinButton: some View {
        Button(action: {
            
        }, label: {
            
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
