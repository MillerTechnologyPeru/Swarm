//
//  URLRequest.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation

public protocol SwarmURLRequest {
    
    static var method: HTTPMethod { get }
        
    static var contentType: String? { get }
    
    var body: Data? { get }
    
    func url(for server: SwarmServer) -> URL
}

public extension URLRequest {
    
    init<T: SwarmURLRequest>(request: T, server: SwarmServer = .production) {
        self.init(url: request.url(for: server))
        self.httpMethod = T.method.rawValue
        self.httpBody = request.body
    }
}
