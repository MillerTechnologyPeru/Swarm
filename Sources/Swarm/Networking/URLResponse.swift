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
        authorization authorizationToken: AuthorizationToken? = nil
    ) async throws -> Response where Request: SwarmURLRequest, Response: SwarmURLResponse {
        var urlRequest = URLRequest(
            request: request,
            server: server
        )
        if let token = authorizationToken {
            urlRequest.setAuthorization(token)
        }
        let (data, urlResponse) = try await self.data(for: urlRequest)
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            fatalError("Invalid response type \(urlResponse)")
        }
        guard httpResponse.statusCode == 200 else {
            throw SwarmNetworkingError.invalidStatusCode(httpResponse.statusCode)
        }
        guard let response = try? Response.decoder.decode(Response.self, from: data) else {
            throw SwarmNetworkingError.invalidResponse(data)
        }
        return response
    }
}
