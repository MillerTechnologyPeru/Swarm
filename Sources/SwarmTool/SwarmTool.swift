//
//  SwarmTool.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation
import ArgumentParser
import Swarm

@main
struct SwarmTool: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(
        abstract: "A command line tool for controlling an Swarm device via serial interface.",
        version: "1.0.0",
        subcommands: [
            DeviceConfiguration.self,
            FirmwareVersion.self,
            
        ],
        defaultSubcommand: DeviceConfiguration.self
    )
}
