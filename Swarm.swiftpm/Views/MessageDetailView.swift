//
//  MessageDetailView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/9/23.
//

import Foundation
import SwiftUI
import Swarm

public struct MessageDetailView: View {
    
    let message: Packet
    
    public var body: some View {
        List {
            Section {
                SubtitleRow(
                    title: Text("Packet"),
                    subtitle: Text(verbatim: message.id.description)
                )
                SubtitleRow(
                    title: Text("Device"),
                    subtitle: Text(verbatim: message.device.description)
                )
                SubtitleRow(
                    title: Text("Length"),
                    subtitle: Text("\(message.length) bytes")
                )
            }
            if let location = try? AssetTrackerMessage(from: message.payload) {
                LocationSection(location: location)
            }
            if let string = String(data: message.payload, encoding: .utf8), string.isEmpty == false {
                Section {
                    Text(verbatim: string)
                } header: {
                    Text("String")
                }
            }
            Section {
                Text(verbatim: "0x" + message.payload.toHexadecimal().uppercased())
            } header: {
                Text("Binary Data")
            }
        }
        .navigationTitle(message.status.description)
    }
}

extension MessageDetailView {
    
    struct LocationSection: View {
        
        let location: AssetTrackerMessage
        
        var body: some View {
            Section {
                ForEach(rows.enumerated().map { (index: $0.offset, view: $0.element) }, id: \.index) {
                    AnyView($0.view)
                }
            } header: {
                Text("Location")
            }
        }
    }
}

internal extension MessageDetailView.LocationSection {
    
    var rows: [any View] {
        [
            SubtitleRow(
                title: Text("Timestamp"),
                subtitle: Text(verbatim: location.timestamp.formatted(date: .long, time: .standard))
            ),
            SubtitleRow(
                title: Text("Longitude"),
                subtitle: Text(verbatim: location.longitude.description)
            ),
            SubtitleRow(
                title: Text("Latitude"),
                subtitle: Text(verbatim: location.latitude.description)
            ),
            SubtitleRow(
                title: Text("Altitude"),
                subtitle: Text("\(location.altitude.description)m")
            ),
            SubtitleRow(
                title: Text("Speed"),
                subtitle: Text("\(location.speed.description)m/s")
            ),
            SubtitleRow(
                title: Text("Heading"),
                subtitle: Text("\(location.heading.description)°")
            ),
            SubtitleRow(
                title: Text("Satellites"),
                subtitle: Text(verbatim: location.satelliteCount.description)
            ),
            SubtitleRow(
                title: Text("GPS Status"),
                subtitle: Text(verbatim: location.gpsStatus.description)
            ),
            SubtitleRow(
                title: Text("Battery"),
                subtitle: Text(verbatim: String(format: "%.3fV", Float(location.batteryVoltage) / 1000))
            ),
            SubtitleRow(
                title: Text("Signal Strength"),
                subtitle: Text("\(location.signalStrength.description)dBm")
            ),
        ]
    }
}

#if DEBUG
struct MessageDetailView_Previews: PreviewProvider {
    
    static let packet = try! JSONDecoder.swarm.decode([Packet].self, from: Data(responseJSON.utf8))[0]
    
    static var previews: some View {
        NavigationView {
            MessageDetailView(message: packet)
        }
    }
}

private extension MessageDetailView_Previews {
    
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
