//
//  Login.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

/// Swarm Login Request
///
/// Use username and password to log in.
public struct LoginRequest: Equatable, Hashable {
    
    public var username: String
    
    public var password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

extension LoginRequest: SwarmURLRequest {
    
    public static var method: HTTPMethod { .post }
    
    public static var contentType: String? { "application/x-www-form-urlencoded" }
        
    public var body: Data? { nil }
    
    public func url(for server: SwarmServer) -> URL {
        let queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        var url = URL(server: server)
            .appendingPathComponent("hive")
            .appendingPathExtension("login")
        if #available(macOS 13, iOS 16, *) {
            url.append(queryItems: queryItems)
        } else {
            var components = URLComponents(string: url.absoluteString)!
            components.queryItems = queryItems
            url = components.url!
        }
        return url
    }
}

/// Swarm Login Response
public struct LoginResponse: Equatable, Hashable, Codable, SwarmURLResponse {
    
    public let token: AuthorizationToken
}

public extension HTTPClient {
    
    func login(
        username: String,
        password: String,
        server: SwarmServer = .production
    ) async throws -> AuthorizationToken {
        let request = LoginRequest(
            username: username,
            password: password
        )
        let response = try await self.response(LoginResponse.self, for: request, server: server)
        return response.token
    }
}
