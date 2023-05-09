//
//  StorePreferences.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

public extension Store {
    
    internal(set) var username: String? {
        get { preferences.username }
        set { preferences.username = newValue }
    }
}

internal extension Store {
    
    func loadPreferences() -> Preferences {
        let preferences = Preferences.standard
        preferencesObserver = preferences.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                self.objectWillChange.send()
            }
        return preferences
    }
}
