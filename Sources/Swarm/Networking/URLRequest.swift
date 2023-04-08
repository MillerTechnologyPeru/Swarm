//
//  URLRequest.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol SwarmURLRequest {
    
    static var method: HTTPMethod { get }
        
    static var contentType: String? { get }
    
    var body: Data? { get }
    
    func url(for server: SwarmServer) -> URL
}

public extension SwarmURLRequest {
    
    static var method: HTTPMethod { .get }
    
    static var contentType: String? { nil }
        
    var body: Data? { nil }
}

public extension URLRequest {
    
    init<T: SwarmURLRequest>(
        request: T,
        server: SwarmServer = .production
    ) {
        self.init(url: request.url(for: server))
        self.httpMethod = T.method.rawValue
        self.httpBody = request.body
    }
}

public extension HTTPClient {
    
    @discardableResult
    func request<Request>(
        _ request: Request,
        server: SwarmServer = .production,
        authorization authorizationToken: AuthorizationToken? = nil,
        statusCode: Int = 200
    ) async throws -> Data where Request: SwarmURLRequest {
        var urlRequest = URLRequest(
            request: request,
            server: server
        )
        if let token = authorizationToken {
            urlRequest.setAuthorization(token)
        }
        let (data, urlResponse) = try await self.data(for: urlRequest)
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            fatalError("Invalid response type \(urlResponse)")
        }
        guard httpResponse.statusCode == statusCode else {
            throw SwarmNetworkingError.invalidStatusCode(httpResponse.statusCode)
        }
        return data
    }
}
