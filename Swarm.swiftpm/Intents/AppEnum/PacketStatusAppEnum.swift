//
//  PacketStatusAppEnum.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import AppIntents
import Swarm

@available(macOS 13.0, iOS 16.0, *)
enum PacketStatusAppEnum: Int, AppEnum, CaseIterable {
    
    /// The packet represents an incoming message from a device.
    case incoming = 0
    
    /// The packet represents an outgoing message to a device.
    case outgoing = 1
    
    /// The packet represents an incoming message that has been acknowledged as seen by the customer.
    case incomingAcknowledged = 2
    
    /// The packet represents an outgoing message that is currently on a groundstation.
    case outgoingOnGroundStation = 3
    
    /// An error occurred while processing the packet, and it cannot be delivered.
    case error = -1
    
    /// A delivery attempt has failed, and the system is retrying the delivery.
    case deliveryRetry = -3
    
    /// A delivery attempt has failed, and the system will not attempt to deliver the packet again.
    case deliveryFailed = -4
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Swarm Packet Status"
    }
    
    static var caseDisplayRepresentations: [PacketStatusAppEnum : DisplayRepresentation] {
        [
            .incoming: "Incoming message",
            .outgoing: "Outgoing message",
            .incomingAcknowledged: "Incoming message acknowledged",
            .outgoingOnGroundStation: "Outgoing message on Ground Station",
            .error: "Error",
            .deliveryRetry: "Delivery retry",
            .deliveryFailed: "Delivery failed"
        ]
    }
}

@available(macOS 13.0, iOS 16.0, *)
extension PacketStatusAppEnum {
    
    init(_ value: Swarm.Packet.Status) {
        self.init(rawValue: value.rawValue)!
    }
}
