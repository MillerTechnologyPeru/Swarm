//
//  ContentView.swift
//  SwarmWatchApp
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            DevicesView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store())
    }
}
