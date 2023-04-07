//
//  SerialMessage.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation
import RegexBuilder

/// Swarm UART Serial Message
public struct SerialMessage: Equatable, Hashable, Codable {
    
    public let type: SerialMessageType
    
    public let body: String?
    
    public init(type: SerialMessageType, body: String? = nil) {
        precondition(body?.isEmpty ?? false == false)
        self.type = type
        self.body = body
    }
}

public extension SerialMessage {
    
    var checksum: NMEAChecksum {
        NMEAChecksum(calculate: checksumBody)
    }
}

internal extension SerialMessage {
    
    func validate(checksum: NMEAChecksum) -> Bool {
        self.checksum == checksum
    }
    
    var checksumBody: String {
        type.rawValue + rawBody
    }
    
    var rawBody: String {
        if let body = self.body {
            return " " + body
        } else {
            return ""
        }
    }
}

// MARK: - CustomStringConvertible

extension SerialMessage: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}

// MARK: - RawRepresentable

extension SerialMessage: RawRepresentable {
    
    public init?(rawValue: String) {
        guard let result = try? SerialMessage.regex.wholeMatch(in: rawValue) else {
            return nil
        }
        let type = SerialMessageType(rawValue: String(result.1))
        let body = result.2.flatMap { String($0) }
        guard let checksum = result.3.flatMap({ NMEAChecksum(rawValue: $0) }) else {
            return nil
        }
        self.init(type: type, body: body)
        // validate checksum
        guard validate(checksum: checksum) else {
            return nil
        }
    }
    
    public var rawValue: String {
        "$"
        + type.rawValue
        + rawBody
        + "*"
        + checksum.rawValue.toHexadecimal()
    }
}

internal extension SerialMessage {
    
    static let regex = Regex {
        Anchor.startOfLine
        "$"
        Capture {
            OneOrMore(.word)
        }
        Optionally {
            " "
            Capture {
                OneOrMore(.any)
            }
        }
        "*"
        Capture {
            Repeat(1...2) {
                OneOrMore(.any)
            }
        } transform: {
            UInt8($0, radix: 16)
        }
        Anchor.endOfLine
    }
    
    static func parse(_ string: String) -> (type: SerialMessageType, body: String?, checksum: NMEAChecksum)? {
        guard let result = try? SerialMessage.regex.wholeMatch(in: string) else {
            return nil
        }
        let type = SerialMessageType(rawValue: String(result.1))
        let body = result.2.flatMap { String($0) }
        guard let checksum = result.3.flatMap({ NMEAChecksum(rawValue: $0) }) else {
            return nil
        }
        return (type, body, checksum)
    }
}
