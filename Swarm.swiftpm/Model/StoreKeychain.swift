//
//  StoreKeychain.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
import Swarm
import KeychainAccess

internal protocol CredentialStorage: AnyObject {
    
    func removeAll() throws
    
    func get(_ key: String) throws -> AuthorizationToken?
    
    func remove(_ key: String) throws
    
    func contains(_ key: String) throws -> Bool
    
    func set(_ newValue: AuthorizationToken, key: String) throws
}

extension KeychainAccess.Keychain: CredentialStorage {
    
    func get(_ key: String) throws -> Swarm.AuthorizationToken? {
        try getString(key, ignoringAttributeSynchronizable: true).flatMap { AuthorizationToken(rawValue: $0) }
    }
    
    func remove(_ key: String) throws {
        try remove(key, ignoringAttributeSynchronizable: true)
    }
    
    func contains(_ key: String) throws -> Bool {
        try contains(key, withoutAuthenticationUI: true)
    }
    
    func set(_ newValue: Swarm.AuthorizationToken, key: String) throws {
        try set(newValue.rawValue, key: key, ignoringAttributeSynchronizable: true)
    }
}

final class InMemoryCredentialStorage: CredentialStorage {
    
    var tokens = [String: AuthorizationToken]()
    
    init() { }
    
    func removeAll() {
        tokens.removeAll(keepingCapacity: true)
    }
    
    func get(_ key: String) -> Swarm.AuthorizationToken? {
        tokens[key]
    }
    
    func remove(_ key: String) {
        tokens[key] = nil
    }
    
    func contains(_ key: String) -> Bool {
        tokens.keys.contains(where: { $0 == key })
    }
    
    func set(_ newValue: Swarm.AuthorizationToken, key: String) {
        tokens[key] = newValue
    }
}

internal extension Store {
    
    func loadKeychain() -> CredentialStorage {
        #if KEYCHAIN
        let keychain = Keychain(service: "com.colemancda.Swarm.AuthorizationToken")
        #else
        let keychain = InMemoryCredentialStorage()
        #endif
        // reset if new installation
        clearKeychainNewInstall()
        return keychain
    }
    
    subscript (token username: String) -> AuthorizationToken? {
        get {
            do {
                guard let token = try keychain.get(username)
                    else { return nil }
                return token
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
                guard let token = newValue else {
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
