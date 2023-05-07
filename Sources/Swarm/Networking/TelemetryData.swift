//
//  Telemetry.swift
//  
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation

/// Represents telemetry data from a device or sensor.
public struct TelemetryData: Equatable, Hashable, Codable, Identifiable, Sendable {
    
    enum CodingKeys: String, CodingKey {
        
        case id                         = "packetId"
        case deviceType
        case device                     = "deviceId"
        case version                    = "telemetryVersion"
        case created                    = "telemetryAt"
        case latitude                   = "telemetryLatitude"
        case longitude                  = "telemetryLongitude"
        case altitude                   = "telemetryAltitude"
        case course                     = "telemetryCourse"
        case speed                      = "telemetrySpeed"
        case batteryVoltage             = "telemetryBatteryVoltage"
        case batteryCurrent             = "telemetryBatteryCurrent"
        case temperature                = "telemetryTemperatureK"
     }
    
    /// A unique identifier for this packet of data.
    public let id: UInt64
    
    /// A numerical identifier for the type of device/sensor that recorded this telemetry data.
    public let deviceType: Int
    
    /// A unique identifier for the device/sensor that recorded this telemetry data.
    public let device: DeviceID
    
    /// The version of the telemetry data format being used.
    public let version: UInt
    
    /// The timestamp at which this telemetry data was recorded.
    public let created: Date
    
    /// The latitude of the device/sensor at the time of recording, in decimal degrees.
    public let latitude: Double
    
    /// The longitude of the device/sensor at the time of recording, in decimal degrees.
    public let longitude: Double
    
    /// The altitude of the device/sensor at the time of recording, in meters above sea level.
    public let altitude: Double
    
    /// The direction the device/sensor was moving at the time of recording, in degrees clockwise from true north.
    public let course: Double
    
    /// The speed at which the device/sensor was moving at the time of recording, in meters per second.
    public let speed: Double
    
    /// The voltage of the device/sensor's battery at the time of recording, in volts.
    public let batteryVoltage: Double
    
    /// The current draw of the device/sensor's battery at the time of recording, in amperes.
    public let batteryCurrent: Double
    
    /// The temperature reading of the device/sensor at the time of recording, in Kelvin.
    public let temperature: Double
}
