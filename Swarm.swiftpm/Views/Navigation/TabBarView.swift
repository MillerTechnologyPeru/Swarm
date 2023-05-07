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
    
    @EnvironmentObject
    private var store: Store
    
    @State
    private var showLogin = false
    
    var body: some View {
        TabView {
            // Devices
            NavigationView {
                DevicesView()
                Text("Select a device")
            }
            .tabItem {
                Label("Devices", systemSymbol: .antennaRadiowavesLeftAndRight)
            }
            
            // Messages
            NavigationView {
                MessagesView()
                Text("Select a message")
            }
            .tabItem {
                Label("Messages", systemSymbol: .mailFill)
            }
            
            // Settings
            NavigationView {
                SettingsView(showLogin: $showLogin)
                
                Image(systemSymbol: .gearshapeFill)
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
            }
            .tabItem {
                Label("Settings", systemSymbol: .gearshapeFill)
            }
            .navigationViewStyle(.stack)
        }
        .onAppear {
            if store.username == nil {
                showLogin = true
            }
        }
        .sheet(isPresented: $showLogin) {
            NavigationView {
                LoginView()
            }
        }
    }
}
#endif
