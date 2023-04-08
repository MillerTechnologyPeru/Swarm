//
//  DevicesView.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm

struct DevicesView: View {
    
    @EnvironmentObject
    var store: Store
    
    @State
    var devices = [DeviceInformation]()
    
    @State
    var sortDescending = false
    
    @State
    var error: String?
    
    @State
    var presentLogin = false
    
    var body: some View {
        LoginView(isPresented: $presentLogin, error: $error) {
            content
        }
        .navigationTitle("Swarm")
        .task { await reload() }
    }
}

extension DevicesView {
    
    func reload() async {
        self.error = nil
        do {
            if store.username != nil {
                // load devices
                self.devices = try await store.devices(sortDescending: sortDescending)
            } else {
                // force login
                presentLogin = true
            }
        }
        catch {
            store.log("Unable to reload devices. \(error)")
            self.error = error.localizedDescription
            self.devices = []
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
            )
        } else if store.username != nil {
            return AnyView(
                StateView(
                    devices: devices
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

extension DevicesView {
    
    struct StateView: View {
        
        let devices: [DeviceInformation]
        
        var body: some View {
            List {
                ForEach(devices) { device in
                    NavigationLink(destination: {
                        Text(verbatim: "\(device)")
                    }, label: {
                        DeviceRow(device: device)
                    })
                }
            }
        }
    }
}

