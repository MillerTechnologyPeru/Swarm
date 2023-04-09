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
    public let id: UInt
    
    /// A unique identifier for the message contained within the packet.
    public let messageId: UInt
    
    /// An identifier for the type of device that sent the packet.
    public let deviceType: UInt
    
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
    public let ackPacketId: Int
    
    /// The status of the packet (0 indicates that it was successfully received).
    public let status: Int
    
    /// The time at which the packet was received by the server (in UTC timezone).
    public let hiveRxTime: Date
    
    public enum CodingKeys: String, CodingKey {
        case id = "packetId"
        case messageId
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
