//
//  WatchConnectivity.swift
//  SwarmWatchApp
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation
import Combine
import WatchConnectivity

/// Messages sent via the Watch connection
enum WatchMessage: Equatable, Hashable, Codable {
    
    case errorResponse(String)
    
    case usernameRequest
    case usernameResponse(String?)
    
    case passwordRequest
    case passwordResponse(String?)
}

extension WatchMessage {
    
    init(from data: Data) throws {
        self = try WatchMessage.decoder.decode(WatchMessage.self, from: data)
    }
    
    func encode() throws -> Data {
        try WatchMessage.encoder.encode(self)
    }
}

private extension WatchMessage {
    
    static let decoder = JSONDecoder()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()
}
