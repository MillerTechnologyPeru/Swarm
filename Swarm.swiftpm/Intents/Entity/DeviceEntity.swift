//
//  DeviceEntity.swift
//  
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import AppIntents
import Swarm

@available(macOS 13.0, iOS 16.0, *)
struct DeviceEntity: AppEntity {
    
    /// The ID of the device.
    let id: DeviceID
    
    /// The name of the device.
    @Property(title: "Serial Number")
    var serialNumber: String
    
    /// The name of the device.
    @Property(title: "Name")
    var name: String
    
    /// Additional comments about the device.
    @Property(title: "Notes")
    var comments: String
    
    /// The type of device.
    @Property(title: "Device Type")
    var deviceType: Int
    
    /// The ID of the organization that owns the device.
    @Property(title: "Organization")
    var organization: Int?
    
    /// The version of the device's firmware.
    @Property(title: "Firmware Version")
    var firmwareVersion: String
    
    /// The version of the device's hardware.
    @Property(title: "Hardware Version")
    var hardwareVersion: String
    
    /// The authentication code for the device.
    @Property(title: "Authentication Code")
    var authCode: String?
    
    /// The creation time of the device.
    @Property(title: "Created")
    var hiveCreationTime: Date
    
    /// The time the device was first heard by the system.
    @Property(title: "First Heard")
    var hiveFirstheardTime: Date
    
    /// The most recent time the device was heard by the system.
    @Property(title: "Last Heard by Hive")
    var hiveLastheardTime: Date
    
    /// The ID of the most recent telemetry report packet sent by the device.
    @Property(title: "Most recent telemetry report")
    var lastTelemetryReportPacket: Int
    
    /// The type of the most recent device that heard the device.
    @Property(title: "Last Heard Device Type")
    var lastHeardByDeviceType: Int
    
    /// The ID of the most recent device that heard the device.
    @Property(title: "Last Heard Device")
    var lastHeardByDeviceId: Int
    
    /// The most recent time the device was heard by any device.
    @Property(title: "Last Heard")
    var lastHeardTime: Date?
    
    /// The most recent counter value reported by the device.
    @Property(title: "Counter")
    var counter: Int
    
    /// The day of the year on which the most recent counter value was reported.
    @Property(title: "Last Heard Counter Day")
    var dayOfYear: Int
    
    /// The most recent counter value heard by any device.
    @Property(title: "Last Heard Counter")
    var lastHeardCounter: Int
    
    /// The day of the year on which the most recent counter value was heard by any device.
    @Property(title: "Last Heard Day of Year")
    var lastHeardDayOfYear: Int
    
    /// The ID of the most recent ground station that heard the device.
    @Property(title: "Last Heard Ground Station")
    var lastHeardByGroundstation: Int
    
    /// The uptime of the device, in seconds.
    @Property(title: "Uptime")
    var uptime: Int?
    
    /// The status of the device.
    @Property(title: "Status")
    var status: Int
    
    /// Whether two-way communication is enabled for the device.
    @Property(title: "Two Way Communication Enabled")
    var twoWayEnabled: Bool
    
    /// Whether data encryption is enabled for the device.
    @Property(title: "Data Encryption Enabled")
    var dataEncryptionEnabled: Bool
    
    /// Additional metadata for the device.
    @Property(title: "Metadata")
    var metadata: [DeviceMetadataEntity]
}

@available(macOS 13.0, iOS 16.0, *)
extension DeviceEntity {
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Swarm Device",
        numericFormat: "\(placeholder: .int) Swarm devices"
    )
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "\(name)",
            subtitle: "\(id.description)",
            image: .init(systemName: "antenna.radiowaves.left.and.right")
        )
    }
    
    typealias DefaultQueryType = DeviceQuery
    
    static var defaultQuery = DeviceQuery()
}

// MARK: - EntityIdentifierConvertible

extension DeviceID: EntityIdentifierConvertible {
    
    public static func entityIdentifier(for entityIdentifierString: String) -> DeviceID? {
        DeviceID.RawValue.init(entityIdentifierString).flatMap { .init(rawValue: $0) }
    }
    
    public var entityIdentifierString: String {
        rawValue.description
    }
}

// MARK: - Value

@available(macOS 13.0, iOS 16.0, *)
extension DeviceEntity {
    
    init(_ value: DeviceInformation) {
        self.init(id: value.id)
        self.serialNumber = value.id.description
        self.name = value.deviceName
        self.comments = value.comments
        self.deviceType = value.deviceType
        self.organization = value.organizationId
        self.firmwareVersion = value.firmwareVersion.rawValue
        self.hardwareVersion = value.hardwareVersion
        self.authCode = value.authCode
        self.hiveCreationTime = value.hiveCreationTime
        self.hiveFirstheardTime = value.hiveFirstheardTime
        self.hiveLastheardTime = value.hiveLastheardTime
        self.lastTelemetryReportPacket = value.lastTelemetryReportPacketId
        self.lastHeardByDeviceType = value.lastHeardByDeviceType
        self.lastHeardByDeviceId = value.lastHeardByDeviceId
        self.lastHeardTime = value.lastHeardTime
        self.counter = value.counter
        self.dayOfYear = value.dayOfYear
        self.lastHeardCounter = value.lastHeardCounter
        self.lastHeardDayOfYear = value.lastHeardDayOfYear
        self.lastHeardByGroundstation = value.lastHeardByGroundstationId
        self.uptime = value.uptime
        self.status = value.status
        self.twoWayEnabled = value.twoWayEnabled
        self.dataEncryptionEnabled = value.dataEncryptionEnabled
        self.metadata = value.metadata
            .sorted { $0.key < $1.key }
            .map { DeviceMetadataEntity(key: $0.key, value: $0.value, device: value.id) }
    }
}
