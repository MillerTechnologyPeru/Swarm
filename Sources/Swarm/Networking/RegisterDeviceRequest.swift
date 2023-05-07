//
//  RegisterDeviceRequest.swift
//  
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation

public struct RegisterDeviceRequest: Equatable, Hashable {
    
    public let authCode: String
    
    public init(authCode: String) {
        self.authCode = authCode
    }
}

extension RegisterDeviceRequest: SwarmURLRequest {
    
    public func url(for server: SwarmServer) -> URL {
        // /hive/api/v1/devices/register?authCode=1234
        URL(server: server)
            .appendingPathComponent("hive")
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
            .appendingPathComponent("devices")
            .appendingPathComponent("register")
            .appending(
                URLQueryItem(name: "authCode", value: authCode)
            )
    }
}

// MARK: - Response

public struct RegisterDeviceResponse: Equatable, Hashable, SwarmURLResponse {
    
    public let device: DeviceInformation
}

extension RegisterDeviceResponse: Decodable {
    
    public init(from decoder: Decoder) throws {
        self.device = try DeviceInformation.init(from: decoder)
    }
}

// MARK: - HTTP Client

public extension HTTPClient {
    
    /// Register a field device using its auth code. Returns the registered device.
    func register(
        authCode: String,
        authorization token: AuthorizationToken,
        server: SwarmServer = .production
    ) async throws -> DeviceInformation {
        let request = RegisterDeviceRequest(
            authCode: authCode
        )
        let response = try await self.response(RegisterDeviceResponse.self, for: request, server: server, authorization: token, statusCode: 200)
        return response.device
    }
}
