//
//  DevicesView.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm
import SFSafeSymbols

struct DevicesView: View {
    
    @EnvironmentObject
    private var store: Store
    
    @State
    private var devices = [DeviceInformation]()
    
    @State
    private var selection: DeviceID?
    
    @State
    private var sortDescending = false
    
    @State
    private var error: String?
    
    @State
    private var isReloading = false
    
    @State
    private var isRefreshing = false
    
    #if os(iOS)
    @State
    private var showScanner = false
    #endif
    
    init() { }
    
    var body: some View {
        content
        .navigationTitle("Swarm")
        .task {
            await reload()
        }
        .onChange(of: store.username) { newValue in
            Task {
                await reload()
            }
        }
        .toolbar {
            #if os(iOS)
            progressIndicator
            scanButton
            #elseif os(macOS)
            Spacer()
            progressIndicator
            refreshButton
            #endif
        }
        .frame(minWidth: 250)
        #if os(iOS)
        .popover(isPresented: $showScanner) {
            NavigationView {
                ScanCodeView {
                    scanResult($0)
                }
            }
        }
        #endif
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
        self.error = nil
        // do nothing if not logged in
        guard store.username != nil else {
            return
        }
        
        // reload
        self.isReloading = true
        defer { isReloading = false }
        
        // fetch devices
        do {
            self.devices = try await store.devices(sortDescending: sortDescending)
        }
        catch {
            store.log("Unable to reload devices. \(error)")
            self.error = error.localizedDescription
            self.devices = []
        }
    }
    
    #if os(iOS)
    func scan() {
        self.showScanner = true
    }
    
    func scanResult(_ result: ScanCodeView.Result) {
        self.showScanner = false
        switch result {
        case let .registered(device):
            self.devices.insert(device, at: 0)
            self.selection = device.id
        }
    }
    #endif
    
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
                    devices: devices,
                    selection: $selection
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
    
    #if os(iOS)
    var scanButton: some View {
        Button(action: {
            scan()
        }, label: {
            Image(systemSymbol: .qrcode)
        })
    }
    #endif
}

extension DevicesView {
    
    struct StateView: View {
        
        let devices: [DeviceInformation]
        
        @Binding
        var selection: DeviceID?
        
        var body: some View {
            #if os(watchOS)
            List(devices) {
                row(for: $0)
            }
            #else
            List(devices, selection: $selection) {
                row(for: $0)
            }
            #endif
        }
    }
}

private extension DevicesView.StateView {
    
    var showLastHeard: Bool {
        #if os(watchOS)
        return false
        #else
        return true
        #endif
    }
    
    func row(for device: DeviceInformation) -> some View {
        NavigationLink(destination: {
            DeviceInformationView(device: device)
        }, label: {
            DeviceRow(device: device, showLastHeard: showLastHeard)
        })
    }
}
