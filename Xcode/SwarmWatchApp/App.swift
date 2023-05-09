//
//  App.swift
//  SwarmWatchApp
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation
import SwiftUI
import Swarm

@main
struct SwarmApp: App {
    
    static let store = Store()
    
    @Environment(\.scenePhase)
    private var phase
    
    @StateObject
    var store: Store
    
    init() {
        let store = SwarmApp.store
        _store = .init(wrappedValue: store)
        store.log("Launching Swarm watchOS v\(Bundle.InfoPlist.shortVersion) (\(Bundle.InfoPlist.version))")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .onChange(of: phase) {
            phaseChanged($0)
        }
    }
}

private extension SwarmApp {
    
    func phaseChanged(_ newValue: ScenePhase) {
        switch newValue {
        case .background:
            break
        case .inactive:
            break
        case .active:
            Task {
                await store.requestUsername()
            }
        default:
            break
        }
    }
}
