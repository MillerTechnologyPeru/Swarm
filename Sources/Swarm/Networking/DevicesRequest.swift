//
//  DevicesRequest.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

/// Get an array of devices visible to the user, filtered by the parameters.
public struct DevicesRequest: Equatable, Hashable {
    
    /// Sort descending by device id if true; sort ascending otherwise. False by default.
    public var sortDescending: Bool // sortDesc
    
    /// Device ID to filter by
    public var deviceID: DeviceID? // deviceid
    
    public init(
        sortDescending: Bool = false,
        deviceID: DeviceID? = nil
    ) {
        self.sortDescending = sortDescending
        self.deviceID = deviceID
    }
}

extension DevicesRequest: SwarmURLRequest {
    
    public func url(for server: SwarmServer) -> URL {
        // /hive/api/v1/devices
        URL(server: server)
            .appendingPathComponent("hive")
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
            .appendingPathComponent("devices")
            .appending(
                URLQueryItem(name: "sortDesc", value: sortDescending.description),
                deviceID.flatMap { URLQueryItem(name: "deviceid", value: $0.rawValue.description) }
            )
    }
}

// MARK: - Response

public struct DevicesResponse: Equatable, Hashable, SwarmURLResponse {
    
    public let devices: [DeviceInformation]
}

extension DevicesResponse: Decodable {
    
    public init(from decoder: Decoder) throws {
        self.devices = try [DeviceInformation].init(from: decoder)
    }
}

// MARK: - HTTP Client

public extension HTTPClient {
    
    /// Get an array of devices visible to the user, filtered by the parameters.
    func devices(
        sortDescending: Bool = false,
        deviceID: DeviceID? = nil,
        authorization token: AuthorizationToken,
        server: SwarmServer = .production
    ) async throws -> [DeviceInformation] {
        let request = DevicesRequest(
            sortDescending: sortDescending,
            deviceID: deviceID
        )
        let response = try await self.response(DevicesResponse.self, for: request, server: server, authorization: token, statusCode: 200)
        return response.devices
    }
}
