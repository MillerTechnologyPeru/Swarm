//
//  TabBarView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import SwiftUI
import Swarm
import SFSafeSymbols

#if os(iOS)
struct TabBarView: View {
    
    var body: some View {
        TabView {
            // Devices
            NavigationView {
                DevicesView()
            }
            .tabItem {
                Label("Devices", systemSymbol: .antennaRadiowavesLeftAndRight)
            }
            .navigationViewStyle(.automatic)
            
            // Messages
            NavigationView {
                MessagesView()
            }
            .tabItem {
                Label("Messages", systemSymbol: .mailFill)
            }
            .navigationViewStyle(.automatic)
            
            // Settings
            NavigationView {
                SettingsView()
                Text("Settings detail")
            }
            .tabItem {
                Label("Settings", systemSymbol: .gearshapeFill)
            }
            .navigationViewStyle(.stack)
        }
    }
}
#endif
