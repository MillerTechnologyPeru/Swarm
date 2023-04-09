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
            Text(verbatim: message.status.description)
            Text(verbatim: "\(message.length) bytes")
            Text("Packet \(message.id.description)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Device \(message.device.description)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(verbatim: message.hiveRxTime.formatted())
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#if DEBUG
struct MessageRow_Previews: PreviewProvider {
    
    static let packet = try! JSONDecoder.swarm.decode([Packet].self, from: Data(responseJSON.utf8))[0]
    
    static var previews: some View {
        NavigationView {
            List {
                MessageRow(message: packet)
                MessageRow(message: packet)
            }
            .navigationTitle("Messages")
        }
    }
}

private extension MessageRow_Previews {
    
    static let responseJSON = #"""
    [
      {
        "packetId": 54189236,
        "messageId": 54189236,
        "deviceType": 1,
        "deviceId": 27662,
        "direction": 1,
        "dataType": 6,
        "userApplicationId": 65002,
        "organizationId": 67028,
        "len": 173,
        "data": "eyJkdCI6MTY4MDgwOTA0NSwibHQiOjMyLjA3MzcsImxuIjotMTE2Ljg3ODMsImFsIjoxNSwic3AiOjAsImhkIjowLCJnaiI6ODMsImdzIjoxLCJidiI6NDA2MCwidHAiOjQwLCJycyI6LTEwNCwidHIiOi0xMTIsInRzIjotOSwidGQiOjE2ODA4MDg5MjcsImhwIjoxNjUsInZwIjoxOTgsInRmIjo5NjY4Mn0=",
        "ackPacketId": 0,
        "status": 0,
        "hiveRxTime": "2023-04-09T01:06:00"
      }
    ]
    """#
}
#endif
