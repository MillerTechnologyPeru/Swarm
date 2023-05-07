//
//  TitleRow.swift
//  
//
//  Created by Alsey Coleman Miller on 5/7/23.
//


import Foundation
import SwiftUI

internal struct TitleRow <Content: View>: View {
    
    let title: LocalizedStringKey
    
    let content: Content?
    
    init(title: LocalizedStringKey, content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            content
        }
    }
}

#if DEBUG
struct TitleRow_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            TitleRow(title: "Accessory") {
                Text("Solar Panel")
            }
            TitleRow(title: "Accessory") {
                Image(systemSymbol: .globe)
            }
            TitleRow(title: "Accessory") {
                AsyncImage(
                    url: URL(string: "https://picsum.photos/id/2/1000/500"),
                    scale: 1.0,
                    content: { $0.resizable().scaledToFit().cornerRadius(10) },
                    placeholder: { ProgressView().progressViewStyle(.circular) }
                )
            }
        }
    }
}
#endif
