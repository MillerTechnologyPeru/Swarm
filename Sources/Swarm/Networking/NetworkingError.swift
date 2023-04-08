//
//  NetworkingError.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

public enum SwarmNetworkingError: Error {
    
    case invalidStatusCode(Int)
    case invalidResponse(Data)
}
