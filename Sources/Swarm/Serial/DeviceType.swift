//
//  DeviceType.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

/// Swarm Device Type
public enum DeviceType: String, Codable, CaseIterable {
    
    /// Tile
    case tile       = "TILE"
    
    /// M138 / Asset Tracker
    case m138       = "M138"
}

// MARK: - CustomStringConvertible

extension DeviceType: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}
