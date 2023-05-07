//
//  QRCode.swift
//  
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation

/// Swarm QR Code
public struct QRCode: Equatable, Hashable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case authenticationCode = "ac"
    }
    
    public let authenticationCode: DeviceAuthenticationCode
}

public extension QRCode {
    
    init(from string: String) throws {
        self = try QRCode.decoder.decode(QRCode.self, from: Data(string.utf8))
    }
    
    func encode() throws -> String {
        let data = try QRCode.encoder.encode(self)
        guard let string = String(data: data, encoding: .utf8) else {
            assertionFailure()
            throw CocoaError(.coderReadCorrupt)
        }
        return string
    }
}

internal extension QRCode {
    
    static let decoder = JSONDecoder()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
}
