//
//  FirmwareVersion.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation
import ArgumentParser
import Swarm

@available(macOS 13.0, *)
extension SwarmTool {
    
    struct FirmwareVersion: ParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: "version",
            abstract: "Read the firmware version."
        )
        
        @Option(help: "The path to the Swarm device serial interface.")
        var device: String = "/dev/ttyUSB0"
        
        func run() throws {
            let device = try Swarm.SerialDevice(path: device)
            try device.send(SerialMessage(type: .firmwareVersion))
            let response = try device.recieve(SerialMessage.FirmwareVersion.self)
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            print("v\(response.version)")
            print("\(formatter.string(from: response.date))")
        }
    }
}
