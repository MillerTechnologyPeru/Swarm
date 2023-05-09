//
//  WatchApplicationContext.swift
//  SwarmWatchApp
//
//  Created by Alsey Coleman Miller on 5/8/23.
//

import Foundation

@available(macOS, unavailable)
@available(tvOS, unavailable)
struct WatchApplicationContext: Equatable, Hashable, Codable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case username
    }
    
    var username: String?
    
    init(username: String? = nil) {
        self.username = username
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
extension WatchApplicationContext {
    
    init(dictionary: [String: NSObject]) {
        self.username = dictionary[CodingKeys.username.rawValue] as? String
    }
    
    var dictionary: [String: NSObject] {
        var dictionary = [String: NSObject]()
        dictionary.reserveCapacity(CodingKeys.allCases.count)
        dictionary[CodingKeys.username.rawValue] = username as NSString?
        return dictionary
    }
}
