import Foundation
import SwiftUI
import Swarm

@main
struct SwarmApp: App {
    
    @StateObject
    var store: Store
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
    
    init() {
        let store = Store()
        _store = .init(wrappedValue: store)
        store.log("Launching Swarm v\(Bundle.InfoPlist.shortVersion) (\(Bundle.InfoPlist.version))")
    }
}
