//
//  SerialDevice.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/13/23.
//

import Foundation
import Swarm

extension Swarm.SerialDevice {
    
    static var devices: [URL] {
        get throws {
            let fileManager = FileManager.default
            let devDirectoryURL = URL(fileURLWithPath: "/dev")
            let contents = try fileManager.contentsOfDirectory(at: devDirectoryURL, includingPropertiesForKeys: nil, options: [])
            let serialDevices = contents.filter { $0.lastPathComponent.hasPrefix("cu") }
            return serialDevices
        }
    }
}
