//
//  UserProfileRequest.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

/// Get a the user context for the current user.
public struct UserProfileRequest: SwarmURLRequest {
    
    public init() { }
    
    public func url(for server: SwarmServer) -> URL {
        // /hive/api/v1/usercontext
        URL(server: server)
            .appendingPathComponent("hive")
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
            .appendingPathComponent("usercontext")
    }
}

extension UserProfile: SwarmURLResponse { }

// MARK: - HTTP Client

public extension HTTPClient {
    
    /// Get a the user context for the current user.
    func userProfile(
        authorization token: AuthorizationToken,
        server: SwarmServer = .production
    ) async throws -> UserProfile {
        return try await self.response(UserProfile.self, for: UserProfileRequest(), server: server, authorization: token, statusCode: 200)
    }
}
