//
//  Store.swift
//
//
//  Created by Alsey Coleman Miller on 3/25/23.
//

import Foundation
import SwiftUI
import Swarm

@MainActor
public final class Store: ObservableObject {
    
    // MARK: - Properties
    
    @Published
    public private(set) var isScanning = false
    
    // MARK: - Initialization
        
    public init() {
        
    }
    
    // MARK: - Methods
    
    public func log(_ message: String) {
        print(message)
    }
}
