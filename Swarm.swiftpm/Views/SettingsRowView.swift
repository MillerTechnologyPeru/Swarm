//
//  SettingsRowView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

#if os(iOS)
import Foundation
import SwiftUI
import Swarm
import SFSafeSymbols

struct SettingsNavigationLink <Destination: View, Image: View> : View {
    
    let title: LocalizedStringKey
    
    let icon: Image
    
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: { destination }, label: {
            SettingsRowLabelView(
                title: title,
                icon: icon
            )
        })
    }
}

struct SettingsButtonRow <Image: View>: View {
    
    let title: LocalizedStringKey
    
    let icon: Image
    
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            SettingsRowLabelView(
                title: title,
                icon: icon
            )
        }
        .buttonStyle(.plain)
    }
}

struct SettingsRowLabelView <Image: View> : View {
    
    let title: LocalizedStringKey
    
    let icon: Image
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            icon.font(.system(size: 22))
            Text(title)
            Spacer(minLength: 0)
        }
    }
}

#if DEBUG
struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section("Settings") {
                    SettingsButtonRow(
                        title: "Sign In",
                        icon: Image(systemSymbol: .personFill)
                            .symbolRenderingMode(.multicolor),
                        action: {
                            
                        }
                    )
                    SettingsNavigationLink(
                        title: "Profile",
                        icon: Image(systemSymbol: .personFill)
                            .symbolRenderingMode(.multicolor),
                        destination: Text("Profile")
                    )
                    SettingsButtonRow(
                        title: "Scan",
                        icon: Image(systemSymbol: .wave3ForwardCircleFill)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue),
                        action: {
                            
                        }
                    )
                    SettingsNavigationLink(
                        title: "Bluetooth",
                        icon: Image(systemSymbol: .wave3ForwardCircleFill)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue),
                        destination: Text("Bluetooth Settings")
                    )
                    SettingsNavigationLink(
                        title: "iCloud",
                        icon: Image(systemSymbol: .cloud)
                            .symbolRenderingMode(.multicolor),
                        destination: Text("iCloud Settings")
                    )
                }
            }
        }
    }
}
#endif
#endif
