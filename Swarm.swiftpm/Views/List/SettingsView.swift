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
    
    @State
    private var showLogin = false
    
    var body: some View {
        LoginView(isPresented: $showLogin, error: $error) {
            List {
                Section {
                    if store.username == nil {
                        SettingsButtonRow(
                            title: "Login",
                            icon: Image(systemSymbol: .personFill),
                            action: {
                                showLogin = true
                            }
                        )
                    } else {
                        SettingsNavigationLink(
                            title: "Profile",
                            icon: Image(systemSymbol: .personFill),
                            destination: {
                                ProfileView()
                            }
                        )
                    }
                } footer: {
                    Text(verbatim: "\nv\(Bundle.InfoPlist.shortVersion) (\(Bundle.InfoPlist.version))")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(Store())
        }
    }
}
#endif
#endif
