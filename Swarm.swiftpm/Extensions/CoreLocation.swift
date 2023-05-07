//
//  CoreLocation.swift
//  
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import CoreLocation
import Intents
import Contacts
import Swarm

extension AssetTrackerMessage {
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}

extension CLPlacemark {
    
    convenience init(message: AssetTrackerMessage, name: String? = nil) {
        self.init(location: CLLocation(message: message), name: name, postalAddress: nil)
    }
}

extension CLLocation {
    
    convenience init(message: AssetTrackerMessage) {
        self.init(
            coordinate: message.coordinate,
            altitude: message.altitude,
            horizontalAccuracy: CLLocationAccuracy(message.horizontalPositionError),
            verticalAccuracy: CLLocationAccuracy(message.verticalPositionError),
            course: message.heading,
            speed: message.speed,
            timestamp: message.timestamp
        )
    }
}
