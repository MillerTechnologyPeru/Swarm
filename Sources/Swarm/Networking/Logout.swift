//
//  Logout.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

struct LogoutRequest: SwarmURLRequest {
    
    public static var method: HTTPMethod { .get }
    
    public static var contentType: String? { nil }
    
    public var body: Data? { nil }
    
    public func url(for server: SwarmServer) -> URL {
        URL(server: server)
            .appendingPathComponent("hive")
            .appendingPathComponent("logout")
    }
}

// MARK: - HTTP Client

public extension HTTPClient {
    
    func logout(
        authorization token: AuthorizationToken,
        server: SwarmServer = .production
    ) async throws {
        let request = LogoutRequest()
        _ = try await self.request(request, server: server, authorization: token, statusCode: 204)
    }
}
