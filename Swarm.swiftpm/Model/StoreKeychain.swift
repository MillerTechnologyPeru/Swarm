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
        
    func get(_ key: String) throws -> String?
    
    func contains(_ key: String) throws -> Bool
    
    func set(_ newValue: String, key: String) async throws

    func remove(_ key: String) async throws
        
    func removeAll() async throws
}

extension KeychainAccess.Keychain: CredentialStorage {
    
    func removeAll() async throws {
        try await Task(priority: .utility) {
            try self.removeAll()
        }.value
    }
    
    func get(_ key: String) throws -> String? {
        try getString(key, ignoringAttributeSynchronizable: true)
    }
    
    func contains(_ key: String) throws -> Bool {
        try contains(key, withoutAuthenticationUI: true)
    }
    
    func remove(_ key: String) async throws {
        try await Task(priority: .utility) {
            try remove(key, ignoringAttributeSynchronizable: true)
        }.value
    }
    
    func set(_ newValue: String, key: String) async throws {
        try await Task(priority: .utility) {
            do {
                try set(newValue, key: key, ignoringAttributeSynchronizable: true)
            }
            catch KeychainAccess.Status.duplicateItem { } // ignore duplicate item error
        }.value
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
        let keychain: CredentialStorage
        if isKeychainEnabled {
            keychain = Keychain(service: "com.colemancda.Swarm.AuthorizationToken")
        } else {
            keychain = InMemoryCredentialStorage()
        }
        // async remove items
        Task(priority: .utility) {
            #if DEBUG
            try? await keychain.removeAll()
            #else
            // reset if new installation
            await clearKeychainNewInstall(keychain)
            #endif
        }
        return keychain
    }
    
    func loadPasswordKeychain() -> CredentialStorage {
        let keychain: CredentialStorage
        if isKeychainEnabled {
            keychain = Keychain(
                server: self.server.rawValue,
                protocolType: .https,
                accessGroup: nil,
                authenticationType: .default
            )
        } else {
            keychain = InMemoryCredentialStorage()
        }
        Task(priority: .utility) {
            // reset if new installation
            await clearKeychainNewInstall(keychain)
        }
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
    }
    
    func setToken(_ newValue: AuthorizationToken?, for username: String) async {
        do {
            guard let token = newValue else {
                try await tokenKeychain.remove(username)
                return
            }
            if try tokenKeychain.contains(username) {
                try await tokenKeychain.remove(username)
            }
            try await tokenKeychain.set(token.rawValue, key: username)
        }
        catch {
            #if DEBUG
            log("Unable retrieve value from keychain. " + error.localizedDescription)
            #endif
            assertionFailure("Unable store value in keychain: \(error)")
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
    }
    
    func setPassword(_ newValue: String?, for username: String) async {
        do {
            guard let password = newValue else {
                try await passwordKeychain.remove(username)
                return
            }
            if try passwordKeychain.contains(username) {
                try await passwordKeychain.remove(username)
            }
            try await passwordKeychain.set(password, key: username)
        }
        catch {
            #if DEBUG
            log("Unable to store value in keychain. " + error.localizedDescription)
            #endif
            assertionFailure("Unable store value in keychain: \(error)")
        }
    }
}

private extension Store {
    
    /// Clear keychain on newly installed app.
    func clearKeychainNewInstall(_ keychain: CredentialStorage) async {
        
        if preferences.isAppInstalled == false {
            preferences.isAppInstalled = true
            do {
                try await keychain.removeAll()
            }
            catch {
                log("⚠️ Unable to clear keychain: \(error.localizedDescription)")
                // TODO: Flush logs
                assertionFailure("Unable to clear keychain")
            }
        }
    }
}
