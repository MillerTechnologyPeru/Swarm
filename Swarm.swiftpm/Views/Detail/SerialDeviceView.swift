//
//  SerialDeviceView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/13/23.
//

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
    
    var body: some View {
        List(messages) { message in
            row(for: message)
        }
        .navigationTitle("Serial")
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
    
    @MainActor
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
                    let message = Message(date: Date(), contents: line)
                    self.messages.append(message)
                }
            }
            catch {
                store.log("Unable to read message. \(error)")
                self.error = error.localizedDescription
            }
        }
    }
    
    func row(for message: Message) -> some View {
        HStack {
            Text(verbatim: message.date.formatted(date: .numeric, time: .standard))
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
}

// MARK: - Supporting Types

extension SerialDeviceView {
    
    struct Message: Equatable, Hashable {
        
        let date: Date
        
        let contents: String
    }
}

extension SerialDeviceView.Message: Identifiable {
    
    var id: Double {
        date.timeIntervalSinceReferenceDate
    }
}
