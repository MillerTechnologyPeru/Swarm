//
//  WatchMessage.swift
//  SwarmWatchApp
//
//  Created by Alsey Coleman Miller on 5/8/23.
//

import Foundation

/// Messages sent via the Watch connection
@available(macOS, unavailable)
@available(tvOS, unavailable)
enum WatchMessage: Equatable, Hashable, Codable {
    
    case errorResponse(String)
    
    case usernameRequest
    case usernameResponse(String?)
    
    case passwordRequest
    case passwordResponse(String?)
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
extension WatchMessage {
    
    var logDescription: String {
        var message = self
        switch message {
        case .errorResponse,
            .usernameRequest,
            .usernameResponse,
            .passwordRequest:
            break
        case let .passwordResponse(response):
            message = .passwordResponse(response.flatMap({ _ in "******" }) ?? "nil")
        }
        return "\(self)"
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
extension WatchMessage {
    
    init(from data: Data) throws {
        self = try WatchMessage.decoder.decode(WatchMessage.self, from: data)
    }
    
    func encode() throws -> Data {
        try WatchMessage.encoder.encode(self)
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
private extension WatchMessage {
    
    static let decoder = JSONDecoder()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()
}
