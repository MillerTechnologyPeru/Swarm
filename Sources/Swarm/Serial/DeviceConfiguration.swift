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
        public let id: UInt32
        
        /// Device type name
        public let type: DeviceType
    }
}

extension SerialMessage.DeviceConfiguration: SwarmDecodableMessage {
    
    public static var messageType: SerialMessageType { .configuration }
    
    public init?(body: String) {
        guard let result = try? SerialMessage.DeviceConfiguration.regex.wholeMatch(in: body),
              let id = result.1, let deviceType = result.2 else {
            return nil
        }
        self.init(id: id, type: deviceType)
    }
}

internal extension SerialMessage.DeviceConfiguration {
    
    static let regex = Regex {
        "DI=0x"
        Capture {
            OneOrMore(.any)
        } transform: {
            UInt32($0, radix: 16)
        }
        ","
        "DN="
        Capture {
            OneOrMore(.any)
        } transform: {
            DeviceType(rawValue: String($0))
        }
    }
}
