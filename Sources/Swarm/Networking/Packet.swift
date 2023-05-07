//
//  Packet.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

/// Swarm Message / Packet
public struct Packet: Equatable, Hashable, Codable, Identifiable {
    
    /// A unique identifier for the packet.
    public let id: ID
    
    /// Swarm message ID.
    ///
    /// There may be multiple messages for a single message ID.
    /// A message ID represents an intent to send a message, but there may be multiple Swarm packets that are required to fulfill that intent.
    ///
    /// For example, if a Hive -> device message fails to reach its destination, automatic retry attempts to send that message will have the same message ID.
    public let message: UInt64
    
    /// An identifier for the type of device that sent the packet.
    public let deviceType: Int
    
    /// A unique identifier for the device that sent the packet.
    public let device: DeviceID
    
    /// The direction of the packet (1 indicates that it is a message sent from the device to a server).
    public let direction: Int
    
    /// An identifier for the type of data contained within the packet (in this case, it is likely to be sensor data).
    public let dataType: Int
    
    /// An identifier for the user application that generated the packet.
    public let userApplicationId: Int
    
    /// An identifier for the organization associated with the device.
    public let organization: Int
    
    /// The length of the data payload in bytes.
    public let length: UInt
    
    /// The base64-encoded data payload.
    public let payload: Data
    
    /// A unique identifier for the acknowledgment packet associated with this packet.
    public let ackPacketId: Packet.ID
    
    /// The status of the packet.
    public let status: Status
    
    /// The time at which the packet was received by the server (in UTC timezone).
    public let hiveRxTime: Date
    
    public enum CodingKeys: String, CodingKey {
        case id = "packetId"
        case message
        case deviceType
        case device = "deviceId"
        case direction
        case dataType
        case userApplicationId
        case organization = "organizationId"
        case length = "len"
        case payload = "data"
        case ackPacketId
        case status
        case hiveRxTime
    }
}

// MARK: - Supporting Types

public extension Packet {
    
    /// Swarm Packet ID
    struct ID: Equatable, Hashable, Codable, RawRepresentable, Sendable {
        
        public let rawValue: UInt64
        
        public init(rawValue: UInt64) {
            self.rawValue = rawValue
        }
    }
}

extension Packet.ID: CustomStringConvertible {
    
    public var description: String {
        rawValue.description
    }
}

extension Packet.ID: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt64) {
        self.init(rawValue: value)
    }
}

public extension Packet {
    
    /// An enumeration representing the status of a message packet.
    enum Status: Int, Codable, CaseIterable {
        
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
    }
}

extension Packet.Status: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .incoming:
            return "Incoming message"
        case .outgoing:
            return "Outgoing message"
        case .incomingAcknowledged:
            return "Incoming message acknowledged"
        case .outgoingOnGroundStation:
            return "Outgoing message on Ground Station"
        case .error:
            return "Error"
        case .deliveryRetry:
            return "Delivery retry"
        case .deliveryFailed:
            return "Delivery failed"
        }
    }
}

