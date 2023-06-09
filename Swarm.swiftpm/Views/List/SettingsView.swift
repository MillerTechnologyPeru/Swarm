//
//  SettingsView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

#if os(iOS)
import Foundation
import SwiftUI
import Swarm

struct SettingsView: View {
    
    @EnvironmentObject
    private var store: Store
    
    @State
    private var error: String?
    
    @Binding
    var showLogin: Bool
    
    var body: some View {
        List {
            Section {
                if let _ = store.username {
                    SettingsNavigationLink(
                        title: "Profile",
                        icon: Image(systemSymbol: .personFill),
                        destination: {
                            ProfileView()
                        }
                    )
                } else {
                    SettingsButtonRow(
                        title: "Login",
                        icon: Image(systemSymbol: .personFill),
                        action: {
                            showLogin = true
                        }
                    )
                }
            } footer: {
                Text(verbatim: "\nv\(Bundle.InfoPlist.shortVersion) (\(Bundle.InfoPlist.version))")
            }
        }
        .listStyle(.automatic)
        .navigationTitle("Settings")
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(showLogin: .constant(false))
                .environmentObject(Store())
        }
        .previewDisplayName("Settings View")
        
        TabBarView()
            .environmentObject(Store())
            .previewDisplayName("Tab Bar")
    }
}
#endif
#endif
