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
        
        let url = URL(string: "https://bumblebee.hive.swarm.space/hive/login?username=colemancda&password=1234")!
        XCTAssertEqual(request.url(for: .production), url)
        
        let client: MockClient = {
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
            return client
        }()
        
        let token = try await client.login(
            username: request.username,
            password: request.password
        )
        
        XCTAssertEqual(token, response.token)
    }
    
    func testLogout() async throws {
        
        let token: AuthorizationToken = "Very1Long_random.L00King2String"
        let url = URL(string: "https://bumblebee.hive.swarm.space/hive/logout")!
        XCTAssertEqual(LogoutRequest().url(for: .production), url)
        
        let client: MockClient = {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Bearer Very1Long_random.L00King2String", forHTTPHeaderField: "Authorization")
            let urlResponse = HTTPURLResponse(url: url, statusCode: 204, httpVersion: nil, headerFields: nil)!
            var client = MockClient()
            client.responses[urlRequest] = (Data(), urlResponse)
            return client
        }()
        
        try await client.logout(authorization: token)
    }
    
    func testDeviceInformation() throws {
        
        var devices = [String]()
        devices.append(
            #"""
            [
              {
                "deviceType": 0,
                "deviceId": 0,
                "deviceName": "",
                "organizationId": 0,
                "authCode": "string",
                "comments": "",
                "hiveCreationTime": "2023-04-08T07:54:22.287Z",
                "hiveFirstheardTime": "2023-04-08T07:54:22.287Z",
                "hiveLastheardTime": "2023-04-08T07:54:22.287Z",
                "firmwareVersion": "",
                "hardwareVersion": "",
                "lastTelemetryReportPacketId": 0,
                "lastHeardByDeviceType": 0,
                "lastHeardByDeviceId": 0,
                "lastHeardTime": "2023-04-08T07:54:22.287Z",
                "counter": 0,
                "dayofyear": 0,
                "lastHeardCounter": 0,
                "lastHeardDayofyear": 0,
                "lastHeardByGroundstationId": 0,
                "uptime": 0,
                "status": 0,
                "twoWayEnabled": false,
                "dataEncryptionEnabled": false,
                "metadata": {
                  "additionalProp1": "string",
                  "additionalProp2": "string",
                  "additionalProp3": "string"
                }
              }
            ]
            """#
        )
        
        for jsonString in devices {
            let devices = try JSONDecoder.swarm.decode([DeviceInformation].self, from: Data(jsonString.utf8))
            XCTAssertFalse(devices.isEmpty)
        }
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
