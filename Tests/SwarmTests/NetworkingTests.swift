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
    
    func testLogin() {
        
        let request = LoginRequest(username: "colemancda", password: "1234")
        XCTAssertEqual(URLRequest(request: request, server: .production).url?.absoluteString, "https://bumblebee.hive.swarm.space/hive.login?username=colemancda&password=1234")
        
    }
}
