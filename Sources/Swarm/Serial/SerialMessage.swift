//
//  SerialMessage.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation

/// Swarm UART Serial Message
public struct SerialMessage: Equatable, Hashable, Codable {
    
    public let type: SerialMessageType
    
    public let body: String
    
    public init(type: SerialMessageType, body: String) {
        self.type = type
        self.body = body
    }
}

public extension SerialMessage {
    
    var checksum: NMEAChecksum {
        NMEAChecksum(calculate: type.rawValue + " " + body)
    }
}

// MARK: - RawRepresentable

extension SerialMessage: RawRepresentable {
    
    public init?(rawValue: String) {
        guard rawValue.first == "$" else {
            return nil
        }
        var type = ""
        var separator = " "
        for character in rawValue {
            
        }
        return nil
    }
    
    public var rawValue: String {
        "$" + type.rawValue + " " + body + "*" + checksum.rawValue.toHexadecimal()
    }
}

// MARK: - SerialMessage

extension SerialMessage: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}
