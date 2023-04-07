import SwiftUI
import Swarm

struct ContentView: View {
    
    @EnvironmentObject
    var store: Store
    
    var body: some View {
        NavigationView {
            EmptyView()
                .navigationTitle("Swarm")
        }
    }
}
