//
//  ErrorResponse.swift
//  
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation

/// Swarm Server Error Response
public struct ErrorResponse: Equatable, Hashable, Decodable {
    
    public let status: String
    public let message: String
    public let debugMessage: String?
    public let timestamp: Date
}

public extension ErrorResponse {
    
    init(from data: Data) throws {
        self = try ErrorResponse.decoder.decode(ErrorResponse.self, from: data)
    }
}

internal extension ErrorResponse {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(ErrorResponse.dateFormatter)
        return decoder
    }()
}

