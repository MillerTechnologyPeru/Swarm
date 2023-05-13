//
//  DeviceConfiguration.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation
import ArgumentParser
import Swarm

@available(macOS 13.0, *)
extension SwarmTool {
    
    struct DeviceConfiguration: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: "configuration",
            abstract: "Read the device configuration."
        )
        
        @Option(help: "The path to the Swarm device serial interface.")
        var device: String = "/dev/ttyUSB0"
        
        func run() async throws {
            let device = try await Swarm.SerialDevice(path: device)
            try await device.send(SerialMessage(type: .configuration))
            let response = try await device.recieve(SerialMessage.DeviceConfiguration.self)
            print("ID: \(response.id)")
            print("Type: \(response.type)")
        }
    }
}
