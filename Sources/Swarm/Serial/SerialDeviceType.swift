//
//  DeviceType.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

/// Swarm Serial Device Type
public enum SerialDeviceType: String, Codable, CaseIterable {
    
    /// Tile
    case tile       = "TILE"
    
    /// M138 / Asset Tracker
    case m138       = "M138"
}

// MARK: - CustomStringConvertible

extension SerialDeviceType: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}
