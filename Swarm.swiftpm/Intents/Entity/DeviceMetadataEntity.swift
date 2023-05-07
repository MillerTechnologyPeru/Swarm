//
//  DeviceMetadataEntity.swift
//  
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import AppIntents
import Swarm

@available(macOS 13.0, iOS 16.0, *)
struct DeviceMetadataEntity: TransientAppEntity {
    
    /// Metadata ID / Key
    @Property(title: "Metadata Key")
    var key: String
    
    /// Metadata value
    @Property(title: "Metadata Value")
    var value: String
    
    /// Device Serial Number
    @Property(title: "Swarm Device")
    var device: String
    
    init() { }
    
    init(key: String, value: String, device: DeviceID) {
        self.init()
        self.key = key
        self.value = value
        self.device = device.description
    }
}

@available(macOS 13.0, iOS 16.0, *)
extension DeviceMetadataEntity {
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Swarm Device Metadata"
    )
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "\(key)",
            subtitle: "\(value)"
        )
    }
}

// MARK: - Identifiable

@available(macOS 13.0, iOS 16.0, *)
extension DeviceMetadataEntity: Identifiable {
    
    var id: String {
        device + "/metadata/" + key
    }
}
