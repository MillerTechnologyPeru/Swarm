//
//  MessageEntity.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import AppIntents
import Swarm

@available(macOS 13.0, iOS 16.0, *)
struct MessageEntity: TransientAppEntity {
    
    var id: Int = 0
    
    @Property(title: "Message ID")
    var messageID: String
    
    init() { }
    
    init(id: UInt64) {
        self.id = Int(id)
        self.messageID = id.description
    }
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: "Swarm Message",
        numericFormat: "\(placeholder: .int) Swarm messages"
    )
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "Message \(id.description)",
            image: .init(systemName: "envelope.fill")
        )
    }
}
