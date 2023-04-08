import SwiftUI
import Swarm

struct ContentView: View {
    
    @EnvironmentObject
    var store: Store
    
    var body: some View {
        #if os(iOS)
        TabBarView()
        #elseif os(macOS)
        NavigationView {
            DevicesView()
        }()
        #endif
    }
}
