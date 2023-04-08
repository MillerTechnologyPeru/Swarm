//
//  NetworkingTests.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation
import XCTest
@testable import Swarm

final class NetworkingTests: XCTestCase {
    
    func testLogin() async throws {
        
        let request = LoginRequest(username: "colemancda", password: "1234")
        let response = LoginResponse(token: "Very1Long_random.L00King2String")
        
        let url = URL(string: "https://bumblebee.hive.swarm.space/hive.login?username=colemancda&password=1234")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let responseJSON = #"""
        {
          "token": "Very1Long_random.L00King2String"
        }
        """#
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        var client = MockClient()
        client.responses[urlRequest] = (Data(responseJSON.utf8), urlResponse)
        let token = try await client.login(
            username: request.username,
            password: request.password
        )
        
        XCTAssertEqual(token, response.token)
        XCTAssertEqual(request.url(for: .production), url)
    }
}

// MARK: - Supporting Types

struct MockClient: HTTPClient {
    
    var responses = [URLRequest: (Data, HTTPURLResponse)]()
    
    init() { }
    
    func data(for request: URLRequest) throws -> (Data, URLResponse) {
        guard let response = responses[request] else {
            throw URLError(.resourceUnavailable)
        }
        return response
    }
}
