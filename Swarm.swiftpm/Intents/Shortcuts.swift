//
//  AppIntents.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation
import AppIntents

@available(macOS 13.0, iOS 16.0, *)
struct AppShortcuts: AppShortcutsProvider {
    
    /// The background color of the tile that Shortcuts displays for each of the app's App Shortcuts.
    static var shortcutTileColor: ShortcutTileColor { .navy }
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: FetchMessagesIntent(device: nil, limit: 0),
            phrases: [
                "Fetch last message with \(.applicationName)",
            ],
            systemImageName: "envelope"
        )
    }
}
