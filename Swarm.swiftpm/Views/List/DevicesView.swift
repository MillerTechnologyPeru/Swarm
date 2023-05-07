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
    private var store: Store
    
    @State
    private var devices = [DeviceInformation]()
    
    @State
    private var sortDescending = false
    
    @State
    private var error: String?
    
    @State
    private var isReloading = false
    
    @State
    private var isRefreshing = false
    
    var body: some View {
        content
        .navigationTitle("Swarm")
        .task {
            await reload()
        }
        .toolbar {
            #if os(iOS)
            progressIndicator
            #elseif os(macOS)
            Spacer()
            progressIndicator
            refreshButton
            #endif
        }
        .frame(minWidth: 250)
    }
}

extension DevicesView {
    
    func refresh() async {
        // reload
        self.isRefreshing = true
        defer { isRefreshing = false }
        await reload()
    }
    
    func reload() async {
        // do nothing if not logged in
        guard store.username != nil else {
            return
        }
        
        // reload
        self.isReloading = true
        defer { isReloading = false }
        
        self.error = nil
        do {
            if store.username != nil {
                // load devices
                self.devices = try await store.devices(sortDescending: sortDescending)
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
                .padding(20)
            )
        } else if store.username != nil {
            return AnyView(
                StateView(
                    devices: devices
                )
                .refreshable {
                    await refresh()
                }
            )
        } else {
            return AnyView(
                Text("Login to view devices")
            )
        }
    }
    
    var progressIndicator: some View {
        HStack {
            if isReloading, !isRefreshing {
                #if os(macOS)
                AnyView(
                    ProgressIndicatorView(style: .spinning, controlSize: .small)
                )
                #else
                AnyView(
                    ProgressView()
                        .progressViewStyle(.circular)
                )
                #endif
            } else {
                EmptyView()
            }
        }
    }
    
    var refreshButton: some View {
        Button(action: {
            Task {
                await reload()
            }
        }, label: {
            Image(systemSymbol: .arrowClockwise)
        })
        .disabled(isReloading)
    }
}

extension DevicesView {
    
    struct StateView: View {
        
        let devices: [DeviceInformation]
        
        var body: some View {
            List {
                ForEach(devices) { device in
                    NavigationLink(destination: {
                        DeviceInformationView(device: device)
                    }, label: {
                        DeviceRow(device: device)
                    })
                }
            }
        }
    }
}

