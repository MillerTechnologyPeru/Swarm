//
//  SerialDevices.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/13/23.
//

import Foundation
import SwiftUI
import Swarm
import SFSafeSymbols

struct SerialDevicesView: View {
    
    @EnvironmentObject
    private var store: Store
    
    @State
    private var devices: [URL] = []
    
    @State
    private var error: String?
    
    var body: some View {
        List(devices, id: \.absoluteString) { url in
            row(for: url)
        }
        .navigationTitle("Serial")
        .onAppear {
            reload()
        }
    }
}

private extension SerialDevicesView {
    
    func reload() {
        self.error = nil
        do {
            self.devices = try SerialDevice.devices
        }
        catch {
            store.log("Unable to load serial devices. \(error)")
            self.devices = []
            self.error = error.localizedDescription
        }
    }
    
    func row(for url: URL) -> some View {
        NavigationLink(destination: {
            SerialDeviceView(path: url.path)
        }, label: {
            Text(verbatim: url.lastPathComponent)
        })
    }
    
    var refreshButton: some View {
        Button(action: {
            reload()
        }, label: {
            Image(systemSymbol: .arrowClockwise)
        })
    }
}
