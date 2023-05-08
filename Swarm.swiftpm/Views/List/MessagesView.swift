//
//  MessagesView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm

struct MessagesView: View {
    
    @EnvironmentObject
    private var store: Store
    
    @State
    var device: DeviceID?
    
    @State
    private var messages = [Packet]()
    
    @State
    private var error: String?
    
    init(device: DeviceID? = nil) {
        self._device = .init(initialValue: device)
    }
    
    var body: some View {
        content
        .navigationTitle("Messages")
        .task { await reload() }
    }
}

extension MessagesView {
    
    func reload() async {
        self.error = nil
        guard store.username != nil else {
            return
        }
        do {
            // load messages
            self.messages = try await store.messages(device: device)
        }
        catch {
            store.log("Unable to reload messages. \(error)")
            self.error = error.localizedDescription
            self.messages = []
        }
    }
    
    var content: some View {
        if let error = self.error {
            return AnyView(
                VStack(alignment: .center, spacing: 20) {
                    Text(verbatim: "⚠️ " + error)
                    Button(action: {
                        Task {
                            await reload()
                        }
                    }, label: {
                        Text("Retry")
                    })
                }
                .padding(20)
            )
        } else if store.username != nil {
            return AnyView(
                StateView(
                    messages: messages
                )
                .refreshable {
                    await reload()
                }
            )
        } else {
            return AnyView(
                Text("Login to view messages")
            )
        }
    }
}

extension MessagesView {
    
    struct StateView: View {
        
        let messages: [Packet]
        
        var body: some View {
            List {
                ForEach(messages) { message in
                    NavigationLink(destination: {
                        MessageDetailView(message: message)
                    }, label: {
                        MessageRow(message: message)
                    })
                }
            }
        }
    }
}
