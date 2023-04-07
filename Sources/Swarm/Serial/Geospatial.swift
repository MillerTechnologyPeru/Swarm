//
//  GeospatialInformation.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

/// Swarm Geospatial Information
public struct GeospatialInformation: Equatable, Hashable, Codable {
    
    /// The latitude is presented in the N basis (negative latitudes are in the southern hemisphere)
    public var latitude: Double
    
    /// The longitude is presented in the E basis (negative longitudes are in the western hemisphere)
    public var longitude: Double
    
    /// Altitude in meters
    public var altitude: Double
    
    /// Course in degrees (0..359) (float).
    ///
    /// Course proceeds clockwise, with 0=north, 90=east, 180=south, and 270=west
    public var course: Double
    
    /// Speed in kilometers per hour (0..999) (float)
    public var speed: Double
}

public extension SerialMessage {
        
    /// Set or query the rate for $GN unsolicited report messages for date and time.
    ///
    /// Also can retrieve the most current $GN message.
    enum GeospatialCommand: Equatable, Hashable {
        
        /// Repeat most recent $GN message.
        case `repeat`
        
        /// Query current $GN rate.
        case getRate
        
        /// Disable or set rate of $GN messages.
        case setRate(UInt32)
    }
}

extension SerialMessage.GeospatialCommand: SwarmEncodableMessage {
    
    public static var messageType: SerialMessageType { .geospatial }
    
    public var body: String {
        switch self {
        case .repeat:
            return "@"
        case .getRate:
            return "?"
        case let .setRate(rate):
            return rate.description
        }
    }
}

// MARK: - Response

public extension SerialMessage {
    
    enum GeospatialResponse: Equatable, Hashable {
        
        case ok
        case error
        case rate(UInt32)
        case information(GeospatialInformation)
    }
}

extension SerialMessage.GeospatialResponse: SwarmDecodableMessage {
    
    public static var messageType: SerialMessageType { .dateTime }
    
    public init?(body: String) {
        if body == "OK" {
            self = .ok
        } else if body == "ERR" {
            self = .error
        } else if let rate = UInt32(body) {
            self = .rate(rate)
        } else {
            let components = body.split(separator: ",")
            guard components.count == 5,
                let latitude = Double(components[0]),
                let longitude = Double(components[1]),
                let altitude = Double(components[2]),
                let course = Double(components[3]),
                let speed = Double(components[4])
                else { return nil }
            let information = GeospatialInformation(
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
                course: course,
                speed: speed
            )
            self = .information(information)
        }
    }
}
