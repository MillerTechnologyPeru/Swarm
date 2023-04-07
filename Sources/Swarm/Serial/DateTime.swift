//
//  DateTime.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation
import RegexBuilder

public extension SerialMessage {
    
    /// Set or query the rate for $DT unsolicited report messages for date and time.
    ///
    /// Also can retrieve the most current $DT message.
    enum DateTimeCommand: Equatable, Hashable, Codable {
        
        /// Repeat most recent $DT message.
        case `repeat`
        
        /// Query current $DT rate.
        case getRate
        
        /// Disable or set rate of $DT messages.
        case setRate(UInt32)
    }
}
