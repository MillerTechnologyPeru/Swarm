//
//  DateTime.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

public extension SerialMessage {
    
    /// Set or query the rate for $DT unsolicited report messages for date and time.
    ///
    /// Also can retrieve the most current $DT message.
    enum DateTimeCommand: Equatable, Hashable {
        
        /// Repeat most recent $DT message.
        case `repeat`
        
        /// Query current $DT rate.
        case getRate
        
        /// Disable or set rate of $DT messages.
        case setRate(UInt32)
    }
}

extension SerialMessage.DateTimeCommand: SwarmEncodableMessage {
    
    public static var messageType: SerialMessageType { .dateTime }
    
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
    
    enum DateTimeResponse: Equatable, Hashable {
        
        case ok
        case error
        case rate(UInt32)
        case dateTime(Date, Flag)
    }
}

extension SerialMessage.DateTimeResponse: SwarmDecodableMessage {
    
    public static var messageType: SerialMessageType { .dateTime }
    
    internal static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    public init?(body: String) {
        if body == "OK" {
            self = .ok
        } else if body == "ERR" {
            self = .error
        } else if let rate = UInt32(body) {
            self = .rate(rate)
        } else {
            let components = body.split(separator: ",")
            guard components.count == 2,
                let date = Self.dateFormatter.date(from: String(components[0])),
                let flag = Flag(rawValue: String(components[1]))
                else { return nil }
            self = .dateTime(date, flag)
        }
    }
}

public extension SerialMessage.DateTimeResponse {
    
    enum Flag: String, Codable, CaseIterable {
        
        case valid = "V"
        case invalid = "I"
    }
}
