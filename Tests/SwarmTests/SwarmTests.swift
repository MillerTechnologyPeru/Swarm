import XCTest
@testable import Swarm

final class SwarmTests: XCTestCase {
    
    func testChecksum() {
        XCTAssertEqual(NMEAChecksum(calculate: "M138 BOOT,RUNNING"), 0x2a)
        
    }
    
    func testSerialMessage() {
        XCTAssertEqual(SerialMessage(type: "M138", body: "BOOT,RUNNING").rawValue, "$M138 BOOT,RUNNING*2a")
    }
}
