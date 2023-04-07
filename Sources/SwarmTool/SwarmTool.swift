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
struct SwarmTool {
    
    func run() throws {
        if #available(macOS 13, *) {
            throw CleanExit.helpRequest(self)
        } else {
            print("Need macOS 13 to run")
        }
    }
}

@available(macOS 13.0, *)
extension SwarmTool: ParsableCommand {
    
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

