import XCTest
@testable import Swarm

final class SwarmTests: XCTestCase {
    
    func testChecksum() {
        XCTAssertEqual(NMEAChecksum(calculate: "M138 BOOT,RUNNING"), 0x2a)
        XCTAssertEqual(SerialMessage(type: .m138, body: "BOOT,RUNNING").rawValue, "$M138 BOOT,RUNNING*2a")
    }
    
    func testSerialMessage() {
        
        let messages = [
            "$M138 BOOT,POWERON,Copyright (c) 2019-22 Swarm Technologies, Inc*2d",
            "$M138 BOOT,POWERON,LPWR=n,WWDG=n,IWDG=n,SFT=n,BOR=Y,PIN=Y,OBL=n*43",
            "$M138 BOOT,VERSION,2022-10-18T22:38:36,v3.0.1*23",
            "$M138 BOOT,DEVICEID,DI=0x006c0e,RDP=0(0xaa)*02",
            "$M138 BOOT,MSGS,IN=0/0,OUT=9/9*2e",
            "$M138 BOOT,RUNNING*2a",
            "$TD OK,4862137892975*2d",
            "$M138 DATETIME*56",
            "$CS*10"
        ]
        
        for string in messages {
            guard let message = SerialMessage(rawValue: string) else {
                XCTFail()
                continue
            }
            XCTAssertEqual(message.rawValue, string)
        }
    }
    
    func testConfiguration() {
        
        guard let message = SerialMessage(rawValue: #"$CS DI=0x000e57,DN=TILE*10"#, validateChecksum: false),
              let configuration = SerialMessage.DeviceConfiguration(message: message)
            else { XCTFail(); return }
        
        XCTAssertEqual(configuration.id, 0x000e57)
        XCTAssertEqual(configuration.type, .tile)
    }
}
