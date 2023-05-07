//
//  DeviceAuthenticationCode.swift
//  
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation

public struct DeviceAuthenticationCode: Equatable, Hashable, RawRepresentable, Codable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - ExpressibleByStringLiteral

extension DeviceAuthenticationCode: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension DeviceAuthenticationCode: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}
