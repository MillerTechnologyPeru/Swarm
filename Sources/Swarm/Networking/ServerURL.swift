//
//  ServerURL.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

public enum SwarmServer: String, Codable {
    
    case production = "https://bumblebee.hive.swarm.space"
}

public extension URL {
    
    init(server: SwarmServer) {
        self.init(string: server.rawValue)!
    }
}
