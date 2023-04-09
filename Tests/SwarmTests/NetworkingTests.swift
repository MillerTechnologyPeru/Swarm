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
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
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
    
    func testDeviceInformation() async throws {
        
        let responseJSON = #"""
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
        
        let request = DevicesRequest(sortDescending: false)
        let devices = try JSONDecoder.swarm.decode([DeviceInformation].self, from: Data(responseJSON.utf8))
        XCTAssertEqual(devices.first?.id, 0x00006c0e)
        
        let url = URL(string: "https://bumblebee.hive.swarm.space/hive/api/v1/devices?sortDesc=false")!
        XCTAssertEqual(request.url(for: .production), url)
        
        let client: MockClient = {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Bearer 1234", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
            let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            var client = MockClient()
            client.responses[urlRequest] = (Data(responseJSON.utf8), urlResponse)
            return client
        }()
        
        let response = try await client.devices(sortDescending: false, authorization: "1234", server: .production)
        XCTAssertEqual(response, devices)
    }
    
    func testUserProfile() async throws {
        
        let responseJSON = #"""
        {
          "userId": 4543,
          "username": "colemancda",
          "organizationId": 67028,
          "billingType": "AUTOMATICALLY_BILLED_MANUALLY_FINALIZED",
          "enabled": true,
          "registered": true,
          "email": "alseycmiller@gmail.com",
          "country": "US",
          "role": "USER",
          "featureFlags": {
            "billing-manual-bill-pay": false
          },
          "twoWayEnabled": false,
          "userApplicationId": 67028
        }
        """#
        
        let request = UserProfileRequest()
        let profile = try JSONDecoder.swarm.decode(UserProfile.self, from: Data(responseJSON.utf8))
        XCTAssertEqual(profile.id, 4543)
        XCTAssertEqual(profile.username, "colemancda")
        XCTAssertEqual(profile.billingType, .automaticallyBilledManuallyFinalized)
        XCTAssert(profile.isEnabled)
        XCTAssertEqual(profile.email, "alseycmiller@gmail.com")
        
        let url = URL(string: "https://bumblebee.hive.swarm.space/hive/api/v1/usercontext")!
        XCTAssertEqual(request.url(for: .production), url)
        
        let client: MockClient = {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Bearer 1234", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
            let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            var client = MockClient()
            client.responses[urlRequest] = (Data(responseJSON.utf8), urlResponse)
            return client
        }()
        
        let response = try await client.userProfile(authorization: "1234", server: .production)
        XCTAssertEqual(response, profile)
    }
    
    func testAssetTracker() throws {
        
        let responseJSON = #"""
        {"dt":1680809045,"lt":31.0737,"ln":-115.8783,"al":15,"sp":0,"hd":0,"gj":83,"gs":1,"bv":4060,"tp":40,"rs":-104,"tr":-112,"ts":-9,"td":1680808927,"hp":165,"vp":198,"tf":96682}
        """#
        
        let message = try AssetTrackerMessage(from: Data(responseJSON.utf8))
        XCTAssertEqual(message.timestamp.description, "2023-04-06 19:24:05 +0000")
        XCTAssertEqual(message.batteryVoltage, 4060)
    }
    
    func testMessage() async throws {
        
        let responseJSON = #"""
        [
          {
            "packetId": 54189236,
            "messageId": 54189236,
            "deviceType": 1,
            "deviceId": 27662,
            "direction": 1,
            "dataType": 6,
            "userApplicationId": 65002,
            "organizationId": 67028,
            "len": 173,
            "data": "eyJkdCI6MTY4MDgwOTA0NSwibHQiOjMyLjA3MzcsImxuIjotMTE2Ljg3ODMsImFsIjoxNSwic3AiOjAsImhkIjowLCJnaiI6ODMsImdzIjoxLCJidiI6NDA2MCwidHAiOjQwLCJycyI6LTEwNCwidHIiOi0xMTIsInRzIjotOSwidGQiOjE2ODA4MDg5MjcsImhwIjoxNjUsInZwIjoxOTgsInRmIjo5NjY4Mn0=",
            "ackPacketId": 0,
            "status": 0,
            "hiveRxTime": "2023-04-09T01:06:00"
          }
        ]
        """#
        
        let messages = try JSONDecoder.swarm.decode([Packet].self, from: Data(responseJSON.utf8))
        XCTAssertEqual(messages.count, 1)
        XCTAssertEqual(messages.first?.id, 54189236)
        XCTAssertEqual(messages.first?.device, 0x00006c0e)
        XCTAssertEqual(messages.first?.hiveRxTime.description, "2023-04-09 01:06:00 +0000")
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
