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
