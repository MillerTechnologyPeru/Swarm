//
//  URLResponse.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

/// Swarm URL Response
public protocol SwarmURLResponse: Decodable {
    
    
}

internal extension SwarmURLResponse {
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        return decoder
    }
}

public extension HTTPClient {
    
    func response<Request, Response>(
        _ response: Response.Type,
        for request: Request,
        server: SwarmServer = .production,
        authorization authorizationToken: AuthorizationToken? = nil,
        statusCode: Int = 200
    ) async throws -> Response where Request: SwarmURLRequest, Response: SwarmURLResponse {
        let data = try await self.request(request, server: server, authorization: authorizationToken, statusCode: statusCode)
        guard let response = try? Response.decoder.decode(Response.self, from: data) else {
            throw SwarmNetworkingError.invalidResponse(data)
        }
        return response
    }
}
