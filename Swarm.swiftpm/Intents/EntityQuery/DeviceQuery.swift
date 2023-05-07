//
//  DeviceQuery.swift
//  
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import AppIntents
import Swarm

@available(macOS 13.0, iOS 16.0, *)
struct DeviceQuery: EntityQuery {
    
    func entities(for identifiers: [DeviceEntity.ID]) async throws -> [DeviceEntity] {
        let store = SwarmApp.store
        // fetch from server
        let devices = try await store.devices()
        // filter locally
        return identifiers.compactMap { id in
            devices.first(where: { $0.id == id })
        }
        .map { .init($0) }
    }
    
    func suggestedEntities() async throws -> [DeviceEntity] {
        let store = SwarmApp.store
        let devices = try await store.devices()
        return devices
            .map { .init($0) }
    }
}

// MARK: - EntityPropertyQuery

@available(macOS 13.0, iOS 16.0, *)
extension DeviceQuery: EntityPropertyQuery {
    
    func entities(matching query: String) async throws -> [DeviceEntity] {
        let store = SwarmApp.store
        // fetch from server
        let devices = try await store.devices()
        // return all results
        guard query.isEmpty == false else {
            return devices.map { .init($0) }
        }
        // filter locally
        return devices
            .filter {
                $0.deviceName.localizedCaseInsensitiveContains(query)
                || $0.comments.localizedCaseInsensitiveContains(query)
                || $0.id.description == query
            }
            .map { .init($0) }
    }
    
    func entities(
        matching predicates: [DeviceQueryPredicate],
        mode: ComparatorMode,
        sortedBy sortDescriptors: [Sort<DeviceEntity>],
        limit: Int?
    ) async throws -> [DeviceEntity] {
        // fetch from server
        var devices = try await store.devices()
        /*
        // filter
        fetchRequest.predicate = predicates.isEmpty ? nil : Predicate.compound(Compound(mode: mode, subpredicates: predicates.map { .init($0) })).toFoundation()
        fetchRequest.fetchLimit = limit ?? 100
        fetchRequest.sortDescriptors = sortDescriptors.map {
            sortDescriptor(for: $0)
        }
         */
        let limit = limit ?? 10
        devices = Array(devices.prefix(limit))
        return devices.map { .init($0) }
    }
    
    static var properties = EntityQueryProperties<DeviceEntity, DeviceQueryPredicate> {
        Property(\DeviceEntity.$name) {
            EqualToComparator { .nameEqualTo($0) }
            ContainsComparator { .nameContains($0) }
        }
        Property(\DeviceEntity.$serialNumber) {
            EqualToComparator { .serialNumberEqualTo($0) }
        }
    }
    
    static var sortingOptions = SortingOptions {
        SortableBy(\DeviceEntity.$name)
        SortableBy(\DeviceEntity.$serialNumber)
        SortableBy(\DeviceEntity.$hiveCreationTime)
    }
}

@available(macOS 13.0, iOS 16.0, *)
private extension DeviceQuery {
    
    var store: Store { SwarmApp.store }
}

// MARK: - Supporting Types

@available(macOS 13.0, iOS 16.0, *)
enum DeviceQueryPredicate {
    
    case nameEqualTo(String)
    case nameContains(String)
    
    case serialNumberEqualTo(String)
}
