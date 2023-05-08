//
//  SerialMessageType.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation

/// Swarm Serial Message Type
public struct SerialMessageType: Equatable, Hashable, RawRepresentable, Codable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - CustomStringConvertible

extension SerialMessageType: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}

// MARK: - ExpressibleByStringLiteral

extension SerialMessageType: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

// MARK: - Definitions

public extension SerialMessageType {
    
    /// Swarm Boot Message for the specified device
    static func boot(_ deviceType: SerialDeviceType) -> SerialMessageType {
        return .init(rawValue: deviceType.rawValue)
    }
    
    /// Swarm Tile Boot Message
    static var tile: SerialMessageType { "TILE" }
    
    /// Swatm M138 Boot Message
    static var m138: SerialMessageType { "M138" }
    
    /// Configuration Settings
    static var configuration: SerialMessageType { "CS" }
    
    /// Date/Time Status
    static var dateTime: SerialMessageType { "DT" }
    
    /// Retrieve Firmware Version
    static var firmwareVersion: SerialMessageType { "FV" }
    
    /// GPS Jamming/Spoofing Indication
    static var gpsJammingSpoofing: SerialMessageType { "GJ" }
    
    /// Geospatial Information
    static var geospatial: SerialMessageType { "GN" }
    
    /// GPIO1 Control
    static var gpio1Control: SerialMessageType { "GP" }
    
    /// GPS Fix Quality
    static var gpsFixQuality: SerialMessageType { "GS" }
    
    /// Messages Received Management
    static var messagesReceived: SerialMessageType { "MM" }
    
    /// Messages to Transmit Management
    static var messagesToTransmit: SerialMessageType { "MT" }
    
    /// Power Off
    static var powerOff: SerialMessageType { "PO" }
    
    /// Power Status
    static var powerStatus: SerialMessageType { "PW" }
    
    /// Restart Device
    static var restartDevice: SerialMessageType { "RS" }
    
    /// Receive Test
    static var receiveTest: SerialMessageType { "RT" }
    
    /// Sleep Mode
    static var sleepMode: SerialMessageType { "SL" }
    
    /// Transmit Data
    static var transmitData: SerialMessageType { "TD" }
    
    /// Receive Data Message
    static var receiveData: SerialMessageType { "RD" }
}
