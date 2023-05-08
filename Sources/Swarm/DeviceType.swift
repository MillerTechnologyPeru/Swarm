//
//  DeviceType.swift
//  
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation

/// Swarm Device Type
public enum DeviceType: UInt, Codable, CaseIterable {
    
    case fieldBee       = 1
    case stratoBee      = 2
    case spaceBee       = 3
    case groundBee      = 4
    case hive           = 5
}

// MARK: - CustomStringConvertible

extension DeviceType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .fieldBee:
            return "Field Bee"
        case .stratoBee:
            return "Stato Bee"
        case .spaceBee:
            return "Space Bee"
        case .groundBee:
            return "Ground Bee"
        case .hive:
            return "Hive"
        }
    }
}
