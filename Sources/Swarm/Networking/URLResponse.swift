//
//  URLResponse.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

/// Swarm URL Response
public protocol SwarmURLResponse: Decodable { }

public extension HTTPClient {
    
    func response<Request, Response>(
        _ response: Response.Type,
        for request: Request,
        server: SwarmServer = .production,
        authorization authorizationToken: AuthorizationToken? = nil,
        statusCode: Int = 200,
        headers: [String: String] = [:]
    ) async throws -> Response where Request: SwarmURLRequest, Response: SwarmURLResponse {
        var headers = headers
        headers["accept"] = "application/json"
        let data = try await self.request(
            request,
            server: server,
            authorization: authorizationToken,
            statusCode: statusCode,
            headers: headers
        )
        guard let response = try? JSONDecoder.swarm.decode(Response.self, from: data) else {
            throw SwarmNetworkingError.invalidResponse(data)
        }
        return response
    }
}
