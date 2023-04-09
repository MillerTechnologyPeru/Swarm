//
//  MessagesRequest.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

/// This endpoint requests a JSON formatted array of messages which are filtered by the parameters.
///
/// Only returns messages from the last 30 days.
///
/// - Note: If a `packetid` is specified, all other filters will be ignored, and the message with that packetid will always be returned unless it's more than 30 days old.
public struct MessagesRequest: Equatable, Hashable {
    
    /// Numeric filter for packet ID.
    ///
    /// Returns single message matching packet ID. Optional.
    public var packet: Packet.ID?
    
    /// Swarm device ID.
    public var device: DeviceID?
    
    /// Result count requested.
    ///
    /// Default is 100. Max is 1000.
    public var count: UInt?
}

extension MessagesRequest: SwarmURLRequest {
    
    public func url(for server: SwarmServer) -> URL {
        // /hive/api/v1/messages
        URL(server: server)
            .appendingPathComponent("hive")
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
            .appendingPathComponent("messages")
            .appending(
                packet.flatMap { URLQueryItem(name: "packetid", value: $0.description) },
                device.flatMap { URLQueryItem(name: "deviceid", value: $0.rawValue.description) },
                count.flatMap { URLQueryItem(name: "count", value: $0.description) }
            )
    }
}


// MARK: - Response

public struct MessagesResponse: Equatable, Hashable, SwarmURLResponse {
    
    public let messages: [Packet]
}

extension MessagesResponse: Decodable {
    
    public init(from decoder: Decoder) throws {
        self.messages = try [Packet].init(from: decoder)
    }
}

// MARK: - HTTP Client

public extension HTTPClient {
    
    /// This endpoint requests a JSON formatted array of messages which are filtered by the parameters.
    ///
    /// Only returns messages from the last 30 days.
    func messages(
        packet: Packet.ID? = nil,
        device: DeviceID? = nil,
        count: UInt? = nil,
        authorization token: AuthorizationToken,
        server: SwarmServer = .production
    ) async throws -> [Packet] {
        let request = MessagesRequest(
            packet: packet,
            device: device,
            count: count
        )
        let response = try await self.response(MessagesResponse.self, for: request, server: server, authorization: token, statusCode: 200)
        return response.messages
    }
}
