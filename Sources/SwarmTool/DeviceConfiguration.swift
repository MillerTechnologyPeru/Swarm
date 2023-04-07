//
//  DeviceConfiguration.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation
import ArgumentParser
import Swarm

extension SwarmTool {
    
    struct DeviceConfiguration: ParsableCommand {
        
        @Option(help: "The path to the Swarm device serial interface.")
        var device: String = "/dev/ttyUSB0"
        
        func run() throws {
            let device = try Swarm.SerialDevice(path: device)
            try device.send(SerialMessage(type: .configuration))
            let response = try device.recieve(SerialMessage.DeviceConfiguration.self)
            print("ID: \(response.id)")
            print("Type: \(response.type)")
        }
    }
}
