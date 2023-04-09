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
    var store: Store
    
    @State
    var messages = [Packet]()
    
    @State
    var device: DeviceID?
    
    @State
    var error: String?
    
    @State
    var presentLogin = false
    
    var body: some View {
        LoginView(isPresented: $presentLogin, error: $error) {
            content
        }
        .navigationTitle("Messages")
        .task { await reload() }
    }
}

extension MessagesView {
    
    func reload() async {
        self.error = nil
        do {
            if store.username != nil {
                // load devices
                self.messages = try await store.messages(device: device)
            }
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
                Button("Login") {
                    presentLogin = true
                }
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
                        Text(verbatim: "\(message)")
                    }, label: {
                        MessageRow(message: message)
                    })
                }
            }
        }
    }
}
