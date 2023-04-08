//
//  DeviceID.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

/// Swarm Device ID
public struct DeviceID: Equatable, Hashable, Codable, RawRepresentable {
    
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

// MARK: - CustomStringConvertible

extension DeviceID: CustomStringConvertible {
    
    public var description: String {
        "0x" + rawValue.toHexadecimal()
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension DeviceID: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt32) {
        self.init(rawValue: value)
    }
}
