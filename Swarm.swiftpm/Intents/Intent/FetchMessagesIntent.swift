//
//  FetchMessagesIntent.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import AppIntents
import Swarm

@available(macOS 13.0, iOS 16.0, *)
struct FetchMessagesIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Fetch Messages"
    
    static let description = IntentDescription(
        "Fetch messages.",
        categoryName: "Message",
        searchKeywords: ["message", "packet"]
    )
    
    @Parameter(
        title: "Device",
        description: "The device to fetch messages for."
    )
    var device: DeviceEntity?
    
    /// The fetch limit of the fetch request.
    @Parameter(
        title: "Limit",
        description: "The fetch limit of the fetch request.",
        default: 100
    )
    var limit: Int
    
    init() { }
    
    init(device: DeviceEntity? = nil, limit: Int = 100) {
        self.init()
        self.device = device
        self.limit = limit
    }
    
    func perform() async throws -> some IntentResult {
        let results = try await store
            .messages(device: device?.id, count: UInt(limit))
            .map { PacketEntity($0) }
        return .result(value: results)
    }
}

// MARK: - Private Methods

@available(macOS 13.0, iOS 16.0, *)
private extension FetchMessagesIntent {
    
    var store: Store {
        SwarmApp.store
    }
}
