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
