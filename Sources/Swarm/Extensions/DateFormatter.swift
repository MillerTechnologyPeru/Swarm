//
//  DateFormatter.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

internal extension DateFormatter {
    
    static var swarm: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
