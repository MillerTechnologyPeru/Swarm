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
    
    func get(_ key: String) throws -> String?
    
    func remove(_ key: String) throws
    
    func contains(_ key: String) throws -> Bool
    
    func set(_ newValue: String, key: String) throws
}

extension KeychainAccess.Keychain: CredentialStorage {
    
    func get(_ key: String) throws -> String? {
        try getString(key, ignoringAttributeSynchronizable: true)
    }
    
    func remove(_ key: String) throws {
        try remove(key, ignoringAttributeSynchronizable: true)
    }
    
    func contains(_ key: String) throws -> Bool {
        try contains(key, withoutAuthenticationUI: true)
    }
    
    func set(_ newValue: String, key: String) throws {
        try set(newValue, key: key, ignoringAttributeSynchronizable: true)
    }
}

final class InMemoryCredentialStorage: CredentialStorage {
    
    var tokens = [String: String]()
    
    init() { }
    
    func removeAll() {
        tokens.removeAll(keepingCapacity: true)
    }
    
    func get(_ key: String) -> String? {
        tokens[key]
    }
    
    func remove(_ key: String) {
        tokens[key] = nil
    }
    
    func contains(_ key: String) -> Bool {
        tokens.keys.contains(where: { $0 == key })
    }
    
    func set(_ newValue: String, key: String) {
        tokens[key] = newValue
    }
}

internal extension Store {
    
    func loadTokenKeychain() -> CredentialStorage {
        #if KEYCHAIN
        let keychain = Keychain(service: "com.colemancda.Swarm.AuthorizationToken")
        // discard all auth tokens for debug builds on launch
        #if DEBUG
        try? keychain.removeAll()
        #endif
        #else
        let keychain = InMemoryCredentialStorage()
        #endif
        // reset if new installation
        clearKeychainNewInstall(keychain)
        return keychain
    }
    
    func loadPasswordKeychain() -> CredentialStorage {
        #if KEYCHAIN
        let keychain = Keychain(
            server: self.server.rawValue,
            protocolType: .https,
            accessGroup: nil,
            authenticationType: .default
        )
        #else
        let keychain = InMemoryCredentialStorage()
        #endif
        // reset if new installation
        clearKeychainNewInstall(keychain)
        return keychain
    }
    
    subscript (token username: String) -> AuthorizationToken? {
        get {
            do {
                guard let token = try tokenKeychain.get(username)
                    else { return nil }
                return .init(rawValue: token)
            } catch {
                #if DEBUG
                log("Unable retrieve value from keychain. " + error.localizedDescription)
                #endif
                assertionFailure("Unable retrieve value from keychain: \(error)")
                return nil
            }
        }
        
        set {
            do {
                guard let token = newValue else {
                    try tokenKeychain.remove(username)
                    return
                }
                if try tokenKeychain.contains(username) {
                    try tokenKeychain.remove(username)
                }
                try tokenKeychain.set(token.rawValue, key: username)
            }
            catch {
                #if DEBUG
                log("Unable retrieve value from keychain. " + error.localizedDescription)
                #endif
                assertionFailure("Unable store value in keychain: \(error)")
            }
        }
    }
    
    subscript (password username: String) -> String? {
        get {
            do {
                guard let password = try passwordKeychain.get(username)
                    else { return nil }
                return password
            } catch {
                #if DEBUG
                log("Unable retrieve value from keychain. " + error.localizedDescription)
                #endif
                assertionFailure("Unable retrieve value from keychain: \(error)")
                return nil
            }
        }
        
        set {
            do {
                guard let password = newValue else {
                    try passwordKeychain.remove(username)
                    return
                }
                if try passwordKeychain.contains(username) {
                    try passwordKeychain.remove(username)
                }
                try passwordKeychain.set(password, key: username)
            }
            catch {
                #if DEBUG
                log("Unable retrieve value from keychain. " + error.localizedDescription)
                #endif
                assertionFailure("Unable store value in keychain: \(error)")
            }
        }
    }
}

private extension Store {
    
    /// Clear keychain on newly installed app.
    func clearKeychainNewInstall(_ keychain: CredentialStorage) {
        
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
