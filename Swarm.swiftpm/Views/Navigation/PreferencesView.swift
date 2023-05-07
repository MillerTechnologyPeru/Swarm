//
//  PreferencesView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

#if os(macOS)
import Foundation
import SwiftUI
import Swarm

struct PreferencesView: View {
    
    @EnvironmentObject
    private var store: Store
    
    var body: some View {
        TabView {
            VStack {
                if let _ = store.username {
                    ProfileView()
                        .frame(
                            minWidth: 300,
                            idealWidth: 300,
                            maxWidth: 450,
                            minHeight: 400,
                            idealHeight: 450,
                            maxHeight: 450
                        )
                } else {
                    LoginView()
                        .padding(.all)
                }
            }
            .tabItem {
                Label("User", systemSymbol: .personFill)
            }
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    
    static let store = Store()
    
    static var previews: some View {
        PreferencesView()
            .environmentObject(store)
    }
}
#endif
