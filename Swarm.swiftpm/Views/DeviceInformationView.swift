//
//  DeviceInformationView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm

struct DeviceInformationView: View {
    
    @EnvironmentObject
    private var store: Store
    
    @State
    var device: DeviceInformation
    
    @State
    private var task: Task<Void, Never>?
    
    @State
    private var error: String?
    
    init(device: DeviceInformation) {
        self._device = .init(initialValue: device)
    }
    
    var body: some View {
        content
            .navigationTitle(device.deviceName)
            .onAppear {
                reload()
            }
            .onDisappear {
                task?.cancel()
            }
    }
}

extension DeviceInformationView {
    
    func reload() {
        self.error = nil
        let id = self.device.id
        let oldTask = self.task
        task = Task {
            await oldTask?.value
            do {
                let response = try await store.devices(deviceID: id)
                guard let device = response.first(where: { $0.id == id }) else {
                    throw SwarmNetworkingError.invalidResponse(Data())
                }
                self.device = device
            }
            catch is CancellationError { }
            catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    var content: some View {
        if let error = self.error {
            return AnyView(
                VStack(alignment: .center, spacing: 20) {
                    Text(verbatim: "⚠️ " + error)
                    Button(action: {
                        reload()
                    }, label: {
                        Text("Retry")
                    })
                }
                .padding(20)
            )
        } else {
            return AnyView(
                StateView(
                    device: device
                )
                .refreshable {
                    reload()
                }
            )
        }
    }
}

extension DeviceInformationView {
    
    struct StateView: View {
        
        let device: DeviceInformation
        
        var body: some View {
            List {
                SubtitleRow(
                    title: Text("Identifier"),
                    subtitle: Text(verbatim: device.id.description)
                )
                if device.comments.isEmpty == false {
                    Text(verbatim: device.comments)
                }
                SubtitleRow(
                    title: Text("Firmware Version"),
                    subtitle: Text(verbatim: device.firmwareVersion.description)
                )
                SubtitleRow(
                    title: Text("Created"),
                    subtitle: Text(verbatim: device.hiveCreationTime.formatted())
                )
                SubtitleRow(
                    title: Text("First Heard"),
                    subtitle: Text(verbatim: device.hiveFirstheardTime.formatted())
                )
                SubtitleRow(
                    title: Text("Last Heard"),
                    subtitle: Text(verbatim: device.hiveLastheardTime.formatted())
                )
            }
            .navigationTitle(device.deviceName)
        }
    }
}
