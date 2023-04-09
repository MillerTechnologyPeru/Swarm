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
    
    func authorizationToken() throws -> AuthorizationToken {
        guard let user = self.username,
            let token = self[token: user] else {
            self.username = nil
            try self.keychain.removeAll()
            throw SwarmNetworkingError.authenticationRequired
        }
        return token
    }
}

public extension Store {
    
    func login(
        username: String,
        password: String
    ) async throws {
        let token = try await urlSession.login(username: username, password: password, server: server)
        // store username in preferences and token in keychain
        self[token: username] = token
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
        let token = try authorizationToken()
        return try await urlSession.devices(
            sortDescending: sortDescending,
            deviceID: deviceID,
            authorization: token,
            server: server
        )
    }
}
