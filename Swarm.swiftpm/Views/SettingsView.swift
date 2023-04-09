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
    
    var body: some View {
        List {
            Section {
                if store.username == nil {
                    SettingsButtonRow(
                        title: "Login",
                        icon: Image(systemSymbol: .personFill),
                        action: {
                            
                        }
                    )
                } else {
                    SettingsNavigationLink(
                        title: "Profile",
                        icon: Image(systemSymbol: .personFill),
                        destination: {
                            Text("Profile")
                        }
                    )
                }
            } footer: {
                Text(verbatim: "\nv\(Bundle.InfoPlist.shortVersion) (\(Bundle.InfoPlist.version))")
            }
        }
        //.listStyle(.grouped)
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
