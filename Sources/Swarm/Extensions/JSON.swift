//
//  JSON.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

public extension JSONDecoder {
    
    static var swarm: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}
