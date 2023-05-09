import Foundation
import XCTest
@testable import Swarm

final class SwarmTests: XCTestCase {
    
    func testQRCode() throws {
        let scanString = #"{"ac":"12345"}"#
        let result = try QRCode(from: scanString)
        XCTAssertEqual(result.authenticationCode, "12345")
    }
}
