//
//  MessageRow.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm

struct MessageRow: View {
    
    let message: Packet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(verbatim: message.id.description)
            Text("Device \(message.device.description)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(verbatim: message.hiveRxTime.formatted())
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(verbatim: "\(message.length) bytes")
        }
    }
}
