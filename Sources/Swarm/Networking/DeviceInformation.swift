//
//  DeviceInfo.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

/// Swarm Device Info
public struct DeviceInformation: Equatable, Hashable, Codable, Identifiable {
    
    internal enum CodingKeys: String, CodingKey {
        
        case id = "deviceId"
        case deviceType
        case deviceName
        case organizationId
        case authCode
        case comments
        case hiveCreationTime
        case hiveFirstheardTime
        case hiveLastheardTime
        case firmwareVersion
        case hardwareVersion
        case lastTelemetryReportPacketId
        case lastHeardByDeviceType
        case lastHeardByDeviceId
        case lastHeardTime
        case counter
        case dayOfYear = "dayofyear"
        case lastHeardCounter
        case lastHeardDayofyear
        case lastHeardByGroundstationId
        case uptime
        case status
        case twoWayEnabled
        case dataEncryptionEnabled
        case metadata
    }
    
    /// The ID of the device.
    public let id: DeviceID
    
    /// The type of device.
    public let deviceType: Int
    
    /// The name of the device.
    public let deviceName: String
    
    /// The ID of the organization that owns the device.
    public let organizationId: Int?
    
    /// The authentication code for the device.
    public let authCode: String?
    
    /// Additional comments about the device.
    public let comments: String?
    
    /// The creation time of the device.
    public let hiveCreationTime: Date
    
    /// The time the device was first heard by the system.
    public let hiveFirstheardTime: Date
    
    /// The most recent time the device was heard by the system.
    public let hiveLastheardTime: Date
    
    /// The version of the device's firmware.
    public let firmwareVersion: FirmwareVersion
    
    /// The version of the device's hardware.
    public let hardwareVersion: String
    
    /// The ID of the most recent telemetry report packet sent by the device.
    public let lastTelemetryReportPacketId: Int
    
    /// The type of the most recent device that heard the device.
    public let lastHeardByDeviceType: Int
    
    /// The ID of the most recent device that heard the device.
    public let lastHeardByDeviceId: Int
    
    /// The most recent time the device was heard by any device.
    public let lastHeardTime: Date?
    
    /// The most recent counter value reported by the device.
    public let counter: Int
    
    /// The day of the year on which the most recent counter value was reported.
    public let dayOfYear: Int
    
    /// The most recent counter value heard by any device.
    public let lastHeardCounter: Int
    
    /// The day of the year on which the most recent counter value was heard by any device.
    public let lastHeardDayofyear: Int
    
    /// The ID of the most recent ground station that heard the device.
    public let lastHeardByGroundstationId: Int
    
    /// The uptime of the device, in seconds.
    public let uptime: Int?
    
    /// The status of the device.
    public let status: Int
    
    /// Whether two-way communication is enabled for the device.
    public let twoWayEnabled: Bool
    
    /// Whether data encryption is enabled for the device.
    public let dataEncryptionEnabled: Bool
    
    /// Additional metadata for the device.
    public let metadata: [String: String]
}
