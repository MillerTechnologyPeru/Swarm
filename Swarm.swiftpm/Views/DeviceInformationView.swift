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
                title: Text(verbatim: "Identifier"),
                subtitle: Text(verbatim: device.id.description)
            )
            Text(verbatim: device.comments)
                .font(.subheadline)
            SubtitleRow(
                title: Text(verbatim: "Firmware Version"),
                subtitle: Text(verbatim: device.firmwareVersion.description)
            )
        }
        .navigationTitle(device.deviceName)
    }
}
