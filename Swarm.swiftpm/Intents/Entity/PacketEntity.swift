//
//  PacketEntity.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import AppIntents
import CoreLocation
import Swarm

@available(macOS 13.0, iOS 16.0, *)
struct PacketEntity: AppEntity {
    
    /// A unique identifier for the packet.
    let id: Packet.ID
    
    @Property(title: "Packet ID")
    var packetID: String
    
    /// Swarm message ID.
    ///
    /// There may be multiple messages for a single message ID.
    /// A message ID represents an intent to send a message, but there may be multiple Swarm packets that are required to fulfill that intent.
    ///
    /// For example, if a Hive -> device message fails to reach its destination, automatic retry attempts to send that message will have the same message ID.
    @Property(title: "Message")
    var message: MessageEntity
    
    /// An identifier for the type of device that sent the packet.
    @Property(title: "Device Type")
    var deviceType: Int
    
    /// A unique identifier for the device that sent the packet.
    //@Property(title: "Device")
    let device: DeviceID
    
    /// The direction of the packet (1 indicates that it is a message sent from the device to a server).
    @Property(title: "Direction")
    var direction: Int
    
    /// An identifier for the type of data contained within the packet (in this case, it is likely to be sensor data).
    @Property(title: "Data Type")
    var dataType: Int
    
    /// An identifier for the user application that generated the packet.
    @Property(title: "User Application")
    var userApplicationId: Int
    
    /// An identifier for the organization associated with the device.
    @Property(title: "Organization")
    var organization: Int
    
    /// The length of the data payload in bytes.
    @Property(title: "Length")
    var length: Int
    
    /// The base64-encoded data payload.
    @Property(title: "Data")
    var payload: IntentFile
    
    /// A unique identifier for the acknowledgment packet associated with this packet.
    @Property(title: "Acknowledgment Packet")
    var ackPacket: String
    
    /// The status of the packet.
    @Property(title: "Status")
    var status: PacketStatusAppEnum
    
    /// The time at which the packet was received by the server (in UTC timezone).
    @Property(title: "Recieved")
    var hiveRxTime: Date
    
    @Property(title: "Location")
    var location: CLPlacemark?
}

@available(macOS 13.0, iOS 16.0, *)
extension PacketEntity {
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Swarm Packet",
        numericFormat: "\(placeholder: .int) Swarm packets"
    )
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "Packet \(id.description)",
            subtitle: "\(hiveRxTime.formatted(.dateTime))",
            image: .init(systemName: "envelope.fill")
        )
    }
    
    typealias DefaultQueryType = PacketQuery
    
    static var defaultQuery = PacketQuery()
}

// MARK: - EntityIdentifierConvertible

@available(macOS 13.0, iOS 16.0, *)
extension Packet.ID: EntityIdentifierConvertible {
    
    public static func entityIdentifier(for entityIdentifierString: String) -> Packet.ID? {
        Packet.ID.RawValue.init(entityIdentifierString).flatMap { .init(rawValue: $0) }
    }
    
    public var entityIdentifierString: String {
        rawValue.description
    }
}

// MARK: - Value

@available(macOS 13.0, iOS 16.0, *)
extension PacketEntity {
    
    init(_ value: Swarm.Packet) {
        self.init(id: value.id, device: value.device)
        self.packetID = value.id.description
        self.message = MessageEntity(id: value.message)
        self.deviceType = value.deviceType
        self.direction = value.direction
        self.userApplicationId = value.userApplicationId
        self.hiveRxTime = value.hiveRxTime
        self.status = .init(value.status)
        self.ackPacket = value.ackPacketId.description
        self.length = Int(value.length)
        self.dataType = value.dataType
        self.organization = value.organization
        self.payload = IntentFile(data: value.payload, filename: "message.json", type: .json)
        self.location = (try? AssetTrackerMessage(from: value.payload))
            .flatMap { .init(message: $0, name: "Packet \(id.description)") }
    }
}
