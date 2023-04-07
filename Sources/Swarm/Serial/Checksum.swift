//
//  Checksum.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation

/// NMEA Checksum
public struct NMEAChecksum: Equatable, Hashable, RawRepresentable {
    
    public let rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension NMEAChecksum: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt8) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension NMEAChecksum: CustomStringConvertible {
    
    public var description: String {
        "0x" + rawValue.toHexadecimal().uppercased()
    }
}

// MARK: - Checksum Calculation

public extension NMEAChecksum {
    
    init(calculate string: String) {
        self = NMEAChecksum.calculate(string.utf8)
    }
    
    init(calculate data: Data) {
        self = NMEAChecksum.calculate(data)
    }
}

internal extension NMEAChecksum {
    
    static func calculate<S>(_ sequence: S) -> NMEAChecksum where S: Sequence, S.Element == UInt8 {
        let cs = sequence.reduce(into: UInt8(0), {
            $0 ^= $1
        })
        return NMEAChecksum(rawValue: cs)
    }
}
