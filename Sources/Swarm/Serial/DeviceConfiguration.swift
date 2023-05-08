//
//  DeviceConfiguration.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation
import RegexBuilder

public extension SerialMessage {
    
    /// Retrieve and display the configuration settings for the Swarm device ID.
    ///
    /// These settings are determined by Swarm for identifying and communicating with each individual device.
    /// Since there are no variable parameters, the correct checksum has been added.
    struct DeviceConfiguration: Equatable, Hashable, Identifiable {
        
        /// Device ID that identifies this device on the Swarm network
        public let id: DeviceID
        
        /// Device type name
        public let type: SerialDeviceType
    }
}

@available(macOS 13.0, iOS 16, *)
extension SerialMessage.DeviceConfiguration: SwarmDecodableMessage {
    
    public static var messageType: SerialMessageType { .configuration }
    
    public init?(body: String) {
        guard let result = try? SerialMessage.DeviceConfiguration.regex.wholeMatch(in: body),
              let id = result.1, let deviceType = result.2 else {
            return nil
        }
        self.init(
            id: id,
            type: deviceType
        )
    }
}

@available(macOS 13.0, iOS 16, *)
internal extension SerialMessage.DeviceConfiguration {
    
    static let regex = Regex {
        "DI=0x"
        Capture {
            OneOrMore(.any)
        } transform: {
            UInt32($0, radix: 16).flatMap { DeviceID(rawValue: $0) }
        }
        ","
        "DN="
        Capture {
            OneOrMore(.any)
        } transform: {
            SerialDeviceType(rawValue: String($0))
        }
    }
}
