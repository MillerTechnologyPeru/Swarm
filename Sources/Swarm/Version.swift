//
//  FirmwareVersion.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

/// Swarm Firmware Version
public struct FirmwareVersion: Equatable, Hashable, RawRepresentable, Codable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - CustomStringConvertible

extension FirmwareVersion: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}
