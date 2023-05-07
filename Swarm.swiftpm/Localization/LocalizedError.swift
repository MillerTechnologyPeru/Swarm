//
//  LocalizedError.swift
//  
//
//  Created by Alsey Coleman Miller on 5/6/23.
//

import Foundation
import Swarm

extension SwarmNetworkingError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .authenticationRequired:
            return NSLocalizedString("Authentication required.", comment: "Authentication required.")
        case .invalidResponse:
            return NSLocalizedString("Invalid server response.", comment: "Invalid server response.")
        case let .invalidStatusCode(code, errorResponse):
            if let response = errorResponse {
                return String(format: NSLocalizedString("Invalid status code %@. %@", comment: "Invalid status code %@. %@"), code.description, response.message)
            } else {
                return String(format: NSLocalizedString("Invalid status code %@.", comment: "Invalid status code %@."), "\(code.description)")
            }
        }
    }
}
