//
//  SidebarView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation
import SwiftUI
import Swarm

#if os(macOS)
struct SidebarView: View {
    
    @EnvironmentObject
    private var store: Store
    
    var body: some View {
        NavigationView {
            DevicesView()
                .frame(minWidth: 250)
            Text("Select a device")
        }
    }
}
#endif
