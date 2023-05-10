//
//  Store.swift
//
//
//  Created by Alsey Coleman Miller on 3/25/23.
//

import Foundation
import Combine
import SwiftUI
import Swarm

@MainActor
public final class Store: ObservableObject {
    
    // MARK: - Properties
    
    public let server = SwarmServer.production
    
    internal let isKeychainEnabled: Bool
    
    internal lazy var fileManager = FileManager()
    
    internal lazy var preferences = loadPreferences()
    
    internal var preferencesObserver: AnyCancellable?
    
    internal lazy var passwordKeychain = loadPasswordKeychain()
    
    internal lazy var tokenKeychain = loadTokenKeychain()
    
    internal lazy var urlSession = loadURLSession()
    
    #if (os(iOS) || os(watchOS)) && canImport(WatchConnection)
    internal lazy var watchConnection = loadWatchConnection()
    
    internal var watchObserver: AnyCancellable?
    
    internal var watchTasks = [Task<Void, Never>]()
    #endif
    
    // MARK: - Initialization
    
    public init() {
        #if KEYCHAIN
        self.isKeychainEnabled = true
        #else
        self.isKeychainEnabled = false
        #endif
    }
    
    internal init(isKeychainEnabled: Bool) {
        self.isKeychainEnabled = isKeychainEnabled
    }
    
    #if DEBUG
    internal static let preview = Store(isKeychainEnabled: false)
    #endif
    
    deinit {
        preferencesObserver?.cancel()
        #if (os(iOS) || os(watchOS)) && canImport(WatchConnection)
        watchObserver?.cancel()
        watchTasks.forEach { $0.cancel() }
        #endif
    }
}
