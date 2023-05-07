//
//  PacketQuery.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import AppIntents
import Swarm

@available(macOS 13.0, iOS 16.0, *)
struct PacketQuery: EntityQuery {
    
    func entities(for identifiers: [PacketEntity.ID]) async throws -> [PacketEntity] {
        // fetch from server
        var packets = [PacketEntity]()
        packets.reserveCapacity(identifiers.count)
        for id in identifiers {
            guard let packet = (try? await store.messages(packet: id))?.first else {
                continue
            }
            packets.append(.init(packet))
        }
        return packets
    }
    
    func suggestedEntities() async throws -> [PacketEntity] {
        try await store.messages(count: 10).map { .init($0) }
    }
}

@available(macOS 13.0, iOS 16.0, *)
private extension PacketQuery {
    
    var store: Store { SwarmApp.store }
}
