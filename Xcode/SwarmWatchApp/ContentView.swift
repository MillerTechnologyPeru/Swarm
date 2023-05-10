//
//  ContentView.swift
//  SwarmWatchApp
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject
    private var store: Store
    
    var body: some View {
        NavigationView {
            if let username = store.username,
               store[password: username] == nil {
                Text("Open iPhone app to sync credentials")
            } else {
                DevicesView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store.preview)
    }
}
