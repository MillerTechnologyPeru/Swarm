//
//  DeviceRow.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm
import SFSafeSymbols

struct DeviceRow: View {
    
    let device: DeviceInformation
    
    let showLastHeard: Bool
    
    init(device: DeviceInformation, showLastHeard: Bool = false) {
        self.device = device
        self.showLastHeard = showLastHeard
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            image
            text
        }
    }
}

private extension DeviceRow {
    
    var image: some View {
        Image(systemSymbol: .antennaRadiowavesLeftAndRight)
            .font(.title2)
            .foregroundColor(.accentColor)
    }
    
    var text: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(verbatim: device.deviceName)
            Text(verbatim: device.id.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            if showLastHeard {
                HStack(spacing: 5) {
                    Text("Last Seen")
                    Text(device.hiveLastheardTime, style: .relative)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
        }
    }
}

#if DEBUG
struct DeviceRow_Previews: PreviewProvider {
    
    static let responseJSON = #"""
        [
          {
            "deviceType": 1,
            "deviceId": 12345,
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
    
    static let devices = try! JSONDecoder.swarm.decode([DeviceInformation].self, from: Data(responseJSON.utf8))
    
    static var previews: some View {
        NavigationView {
            List {
                DeviceRow(device: devices[0], showLastHeard: false)
                DeviceRow(device: devices[0], showLastHeard: true)
            }
            .navigationTitle("Swarm")
        }
    }
}
#endif
