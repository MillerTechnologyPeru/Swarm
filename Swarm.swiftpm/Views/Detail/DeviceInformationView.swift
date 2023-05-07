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
                Section {
                    SubtitleRow(
                        title: Text("Identifier"),
                        subtitle: Text(verbatim: device.id.description)
                    )
                    if device.comments.isEmpty == false {
                        SubtitleRow(
                            title: Text("Description"),
                            subtitle: Text(verbatim: device.comments)
                        )
                    }
                    SubtitleRow(
                        title: Text("Device Type"),
                        subtitle: Text(verbatim: device.deviceType.description)
                    )
                    SubtitleRow(
                        title: Text("Firmware Version"),
                        subtitle: Text(verbatim: device.firmwareVersion.description)
                    )
                    if device.hardwareVersion.isEmpty == false {
                        SubtitleRow(
                            title: Text("Hardware Version"),
                            subtitle: Text(verbatim: device.hardwareVersion)
                        )
                    }
                }
                
                Section {
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
                    if let uptime = device.uptime {
                        SubtitleRow(
                            title: Text("Uptime"),
                            subtitle: Text("\(uptime)s")
                        )
                    }
                    SubtitleRow(
                        title: Text("Status"),
                        subtitle: Text(verbatim: device.status.description)
                    )
                    SubtitleRow(
                        title: Text("Two Way Enabled"),
                        subtitle: Text(verbatim: device.twoWayEnabled.description)
                    )
                    SubtitleRow(
                        title: Text("Data Encryption Enabled"),
                        subtitle: Text(verbatim: device.dataEncryptionEnabled.description)
                    )
                }
                
                NavigationLink("Messages") {
                    MessagesView(device: device.id)
                }
            }
            .navigationTitle(device.deviceName)
        }
    }
}

#if DEBUG
struct DeviceInformationView_Previews: PreviewProvider {
    
    static let responseJSON = #"""
        [
          {
            "deviceType": 1,
            "deviceId": 27662,
            "deviceName": "My Swarm Device",
            "comments": "Tracker",
            "hiveCreationTime": "2022-10-04T18:46:02",
            "hiveFirstheardTime": "2023-03-26T14:30:51",
            "hiveLastheardTime": "2023-04-06T20:00:35",
            "firmwareVersion": "v3.0.1",
            "hardwareVersion": "",
            "lastTelemetryReportPacketId": 53906350,
            "lastHeardByDeviceType": 3,
            "lastHeardByDeviceId": 1530,
            "counter": 0,
            "dayofyear": 0,
            "lastHeardCounter": 98,
            "lastHeardDayofyear": 96,
            "lastHeardByGroundstationId": 248872,
            "status": 0,
            "twoWayEnabled": false,
            "dataEncryptionEnabled": true,
            "metadata": {
              "device:type": "Other"
            }
          }
        ]
        """#
    
    static let device = try! JSONDecoder.swarm.decode([DeviceInformation].self, from: Data(responseJSON.utf8)).first!
    
    static var previews: some View {
        Group {
            NavigationView {
                DeviceInformationView.StateView(device: device)
            }
        }
    }
}
#endif
