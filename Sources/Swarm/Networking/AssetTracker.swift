//
//  AssetTracker.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

/// Swarm Asset Tracker Message
public struct AssetTrackerMessage: Equatable, Hashable, Codable {
    
    /// Timestamp of the data in Unix time (seconds since January 1, 1970).
    public let timestamp: Int
    
    /// Latitude of the location in degrees.
    public let latitude: Double

    /// Longitude of the location in degrees.
    public let longitude: Double

    /// Altitude of the location in meters above sea level.
    public let altitude: Double

    /// Speed of the device in meters per second.
    public let speed: Double

    /// Heading direction of the device in degrees from true north.
    public let heading: Double

    /// GPS signal quality in terms of the number of satellites being tracked.
    public let satelliteCount: Int

    /// GPS status, where 1 means GPS fix is available and 0 means GPS fix is not available.
    public let gpsStatus: Int

    /// Battery voltage of the device in millivolts.
    public let batteryVoltage: Int

    /// Device temperature in Celsius.
    public let temperature: Int

    /// Cellular signal strength in dBm.
    public let signalStrength: Int

    /// Cellular signal strength in dBm relative to the reference level.
    public let signalStrengthReference: Int

    /// Time offset in seconds between the device's GPS clock and the cellular network's clock.
    public let timeOffset: Int

    /// Timestamp of the last successful GPS fix in Unix time (seconds since January 1, 1970).
    public let lastSuccessfulFixTimestamp: Int

    /// Horizontal position error in meters.
    public let horizontalPositionError: Int

    /// Vertical position error in meters.
    public let verticalPositionError: Int

    /// Time since the device was last powered on in milliseconds.
    public let timeSinceLastPowerOn: Int

    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case latitude = "lt"
        case longitude = "ln"
        case altitude = "al"
        case speed = "sp"
        case heading = "hd"
        case satelliteCount = "gj"
        case gpsStatus = "gs"
        case batteryVoltage = "bv"
        case temperature = "tp"
        case signalStrength = "rs"
        case signalStrengthReference = "tr"
        case timeOffset = "ts"
        case lastSuccessfulFixTimestamp = "td"
        case horizontalPositionError = "hp"
        case verticalPositionError = "vp"
        case timeSinceLastPowerOn = "tf"
    }
}

// MARK: - Supporting Types


