//
//  MapView.swift
//  SwarmApp
//
//  Created by Alsey Coleman Miller on 4/9/23.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Swarm

struct AssetTrackerMapView: View {
    
    let location: AssetTrackerMessage
    
    @State
    private var region: MKCoordinateRegion
    
    init(location: AssetTrackerMessage) {
        self.location = location
        self._region = .init(
            initialValue: MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01)
                )
            )
    }
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: [location]
        ) { location in
            MapAnnotation(coordinate: location.coordinate) {
                AssetTrackerAnnotationView(location: location)
            }
        }
        .navigationTitle("Location")
    }
}

struct AssetTrackerAnnotationView: View {
    
  @State private var showTitle = true
  
    let location: AssetTrackerMessage
  
    var body: some View {
    VStack(spacing: 0) {
        Text(verbatim: location.timestamp.formatted())
        .font(.callout)
        .padding(5)
        .background(Color.white)
        .foregroundColor(Color.black)
        .cornerRadius(10)
        .opacity(showTitle ? 0 : 1)
      
      Image(systemName: "mappin.circle.fill")
        .font(.title)
        .foregroundColor(.red)
      
      Image(systemName: "arrowtriangle.down.fill")
        .font(.caption)
        .foregroundColor(.red)
        .offset(x: 0, y: -5)
    }
    .onTapGesture {
      withAnimation(.easeInOut) {
        showTitle.toggle()
      }
    }
  }
}

#if DEBUG
struct AssetTrackerMapView_Previews: PreviewProvider {
    
    static let location = try! AssetTrackerMessage(from: Data(messageJSON.utf8))
    
    static var previews: some View {
        NavigationView {
            AssetTrackerMapView(location: location)
        }
    }
}

private extension AssetTrackerMapView_Previews {
    
    static let messageJSON = #"{"dt":1680809045,"lt":32.0737,"ln":-116.8783,"al":15,"sp":0,"hd":0,"gj":83,"gs":1,"bv":4060,"tp":40,"rs":-104,"tr":-112,"ts":-9,"td":1680808927,"hp":165,"vp":198,"tf":96682}"#
}
#endif
