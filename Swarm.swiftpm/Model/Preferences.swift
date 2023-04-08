//
//  Preferences.swift
//
//
//  Created by Alsey Coleman Miller on 3/25/23.
//

import Foundation
import Combine

/// Preferences
public final class Preferences: ObservableObject {
    
    // MARK: - Preferences
    
    private let userDefaults: UserDefaults
    
    // MARK: - Initialization
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Methods
    
    private subscript <T> (key: Key) -> T? {
        get { userDefaults.object(forKey: key.rawValue) as? T }
        set {
            objectWillChange.send()
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }
}

// MARK: - App Group

public extension Preferences {
    
    static let standard = Preferences(userDefaults: .standard)
}

public extension Preferences {
    
    convenience init?(suiteName: String) {
        guard let userDefaults = UserDefaults(suiteName: suiteName)
            else { return nil }
        self.init(userDefaults: userDefaults)
    }
}

// MARK: - Accessors

public extension Preferences {
    
    var isAppInstalled: Bool {
        get { return self[.isAppInstalled] ?? false }
        set { self[.isAppInstalled] = newValue }
    }
    
    var username: String? {
        get { return self[.username] }
        set { self[.username] = newValue }
    }
}

// MARK: - Supporting Types

public extension Preferences {
    
    enum Key: String, CaseIterable {
        
        case isAppInstalled     = "com.colemancda.Swarm.UserDefaults.AppInstalled"
        case username           = "com.colemancda.Swarm.UserDefaults.Username"
    }
}
