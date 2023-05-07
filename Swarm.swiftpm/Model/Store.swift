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
import KeychainAccess

@MainActor
public final class Store: ObservableObject {
    
    // MARK: - Properties
    
    public let server = SwarmServer.production
    
    internal lazy var fileManager = FileManager()
    
    internal lazy var preferences = loadPreferences()
    
    internal var preferencesObserver: AnyCancellable?
    
    internal lazy var passwordKeychain = loadPasswordKeychain()
    
    internal lazy var tokenKeychain = loadTokenKeychain()
    
    internal lazy var urlSession = loadURLSession()
    
    internal var token: AuthorizationToken?
    
    // MARK: - Initialization
    
    deinit {
        preferencesObserver?.cancel()
    }
}
