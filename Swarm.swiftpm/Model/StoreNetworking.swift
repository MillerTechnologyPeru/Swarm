//
//  StoreNetworking.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import Swarm

internal extension Store {
    
    func loadURLSession() -> URLSession {
        let urlSession = URLSession(configuration: .ephemeral)
        return urlSession
    }
}

private extension Store {
    
    func authorizationToken() throws -> AuthorizationToken {
        guard let user = self.username,
            let token = self[token: user] else {
            self.username = nil
            try self.tokenKeychain.removeAll()
            throw SwarmNetworkingError.authenticationRequired
        }
        return token
    }
    
    func authorized<T>(
        _ block: (AuthorizationToken) async throws -> T
    ) async throws -> T {
        // refresh token if logged in but missing token
        if let username = self.username, self[token: username] == nil {
            try await refreshAuthorizationToken()
        }
        let token = try authorizationToken()
        do {
            return try await block(token)
        }
        catch SwarmNetworkingError.invalidStatusCode(401) {
            try await refreshAuthorizationToken()
            // retry once
            let token = try authorizationToken()
            return try await block(token)
        }
    }
    
    func refreshAuthorizationToken() async throws {
        guard let username = self.username else {
            throw SwarmNetworkingError.authenticationRequired
        }
        // remove invalid token
        self[token: username] = nil
        guard let password = self[password: username] else {
            throw SwarmNetworkingError.authenticationRequired
        }
        // login again for new token
        try await login(username: username, password: password)
    }
}

public extension Store {
    
    func login(
        username: String,
        password: String
    ) async throws {
        let token = try await urlSession.login(
            username: username,
            password: password,
            server: server
        )
        // store username in preferences and token and password in keychain
        self[token: username] = token
        self[password: username] = password
        self.username = username
    }
    
    func logout() async throws {
        let token = try authorizationToken()
        // remove from preferences and keychain
        if let username = self.username {
            self.username = nil
            self[token: username] = nil
        }
        // invalidate token for server
        try await urlSession.logout(authorization: token, server: server)
    }
    
    /// Get an array of devices visible to the user, filtered by the parameters.
    func devices(
        sortDescending: Bool = false,
        deviceID: DeviceID? = nil
    ) async throws -> [DeviceInformation] {
        try await authorized { token in
            try await urlSession.devices(
                sortDescending: sortDescending,
                deviceID: deviceID,
                authorization: token,
                server: server
            )
        }
    }
    
    /// Get a the user context for the current user.
    func userProfile() async throws -> UserProfile {
        try await authorized { token in
            try await urlSession.userProfile(
                authorization: token,
                server: server
            )
        }
    }
    
    /// This endpoint requests a JSON formatted array of messages which are filtered by the parameters.
    ///
    /// Only returns messages from the last 30 days.
    func messages(
        packet: Packet.ID? = nil,
        device: DeviceID? = nil,
        count: UInt? = nil
    ) async throws -> [Packet] {
        try await authorized { token in
            try await urlSession.messages(
                packet: packet,
                device: device,
                count: count,
                authorization: token,
                server: server
            )
        }
    }
}
