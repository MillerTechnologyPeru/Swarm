//
//  FirmwareVersion.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

public extension SerialMessage {
    
    /// Swarm Device Firmware Version
    struct FirmwareVersion: Equatable, Hashable {
        
        public let date: Date
        
        public let version: String
    }
}

@available(macOS 13.0, iOS 16.0, *)
extension SerialMessage.FirmwareVersion: SwarmCodableMessage {
    
    public static var messageType: SerialMessageType { .firmwareVersion }
    
    internal static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    public init?(body: String) {
        let components = body.split(separator: ",v")
        guard components.count == 2,
            let date = Self.dateFormatter.date(from: String(components[0]))
            else { return nil }
        
        self.date = date
        self.version = String(components[1])
    }
    
    public var body: String {
        Self.dateFormatter.string(from: date) + ",v" + version
    }
}

@available(macOS 13.0, iOS 16, *)
extension SerialMessage.FirmwareVersion: RawRepresentable { }
