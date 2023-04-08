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
    
    public init(sortDescending: Bool = false) {
        self.sortDescending = sortDescending
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
                URLQueryItem(name: "sortDesc", value: sortDescending.description)
            )
    }
}
