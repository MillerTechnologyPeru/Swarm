//
//  NetworkingError.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

/// Swarm REST API Error
public enum SwarmNetworkingError: Error {
    
    case authenticationRequired
    case invalidStatusCode(Int, Swarm.ErrorResponse? = nil)
    case invalidResponse(Data)
}
