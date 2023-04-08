//
//  StoreKeychain.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import Swarm
import KeychainAccess

internal extension Store {
    
    func loadKeychain() -> Keychain {
        let keychain = Keychain(service: "com.colemancda.Swarm.AuthorizationToken")
        // reset if new installation
        clearKeychainNewInstall()
        return keychain
    }
    
    subscript (token username: String) -> AuthorizationToken? {
        get {
            do {
                guard let token = try keychain.getString(username)
                    else { return nil }
                return AuthorizationToken(rawValue: token)
            } catch {
                #if DEBUG
                log(error.localizedDescription)
                #endif
                assertionFailure("Unable retrieve value from keychain: \(error)")
                return nil
            }
        }
        
        set {
            do {
                guard let token = newValue?.rawValue else {
                    try keychain.remove(username)
                    return
                }
                if try keychain.contains(username) {
                    try keychain.remove(username)
                }
                try keychain.set(token, key: username)
            }
            catch {
                #if DEBUG
                log(error.localizedDescription)
                #endif
                assertionFailure("Unable store value in keychain: \(error)")
            }
        }
    }
}

private extension Store {
    
    /// Clear keychain on newly installed app.
    private func clearKeychainNewInstall() {
        
        if preferences.isAppInstalled == false {
            preferences.isAppInstalled = true
            do { try keychain.removeAll() }
            catch {
                log("⚠️ Unable to clear keychain: \(error.localizedDescription)")
                // TODO: Flush logs
                assertionFailure("Unable to clear keychain")
            }
        }
    }
}
