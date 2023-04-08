//
//  NetworkingTests.swift
//  
//
//  Created by Alsey Coleman Miller on 4/7/23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
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
        
        let jsonString = #"""
            [
              {
                "deviceType": 1,
                "deviceId": 27662,
                "deviceName": "My Swarm Device",
                "comments": "Tracker",
                "hiveCreationTime": "2022-10-04T18:46:02",
                "hiveFirstheardTime": "2023-03-26T14:30:51",
                "hiveLastheardTime": "2023-04-06T20:00:35",
                "firmwareVersion": "v3.0.1",
                "hardwareVersion": "",
                "lastTelemetryReportPacketId": 53906350,
                "lastHeardByDeviceType": 3,
                "lastHeardByDeviceId": 1530,
                "counter": 0,
                "dayofyear": 0,
                "lastHeardCounter": 98,
                "lastHeardDayofyear": 96,
                "lastHeardByGroundstationId": 248872,
                "status": 0,
                "twoWayEnabled": false,
                "dataEncryptionEnabled": true,
                "metadata": {
                  "device:type": "Other"
                }
              }
            ]
            """#
        
        let devices = try JSONDecoder.swarm.decode([DeviceInformation].self, from: Data(jsonString.utf8))
        XCTAssertEqual(devices.first?.id, 0x00006c0e)
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
