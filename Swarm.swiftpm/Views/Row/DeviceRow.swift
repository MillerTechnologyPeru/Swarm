//
//  DeviceRow.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm

struct DeviceRow: View {
    
    let device: DeviceInformation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(verbatim: device.deviceName)
            Text(verbatim: device.id.description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
