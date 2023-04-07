import Foundation
import XCTest
@testable import Swarm

@available(macOS 13.0, *)
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
            "$CS*10",
            "$CS DI=0x000e57,DN=TILE*10",
            "$DT @*70",
            "$DT 20190408195123,V*41",
            "$DT 300*03",
            "$DT OK*34",
            "$DT ?*0f",
            "$DT 60*36",
            "$FV*10",
            "$FV 2021-07-16-00:10:21,v1.1.0*74",
            "$GJ @*6d",
            "$GJ 1,23*31",
            "$GJ 3600*28",
            "$GJ OK*29",
            "$GJ ?*12",
            "$GJ 10*2c",
            "$GN @*69",
            "$GN 37.8921,-122.0155,77,89,2*01",
            "$GN 30*2a",
            "$GN OK*2d",
            "$GN ?*16",
            "$GN 15*2d"
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
        
        guard let configuration = SerialMessage.DeviceConfiguration(rawValue: #"$CS DI=0x006c0e,DN=M138*24"#)
            else { XCTFail(); return }
        
        XCTAssertEqual(configuration.id, 0x006c0e)
        XCTAssertEqual(configuration.type, .m138)
    }
    
    func testDateTime() {
        
        let date = SerialMessage.DateTimeResponse.dateFormatter.date(from: "20190408195123")!
        XCTAssertEqual(date.description, "2019-04-08 19:51:23 +0000")
        XCTAssertEqual(SerialMessage.DateTimeCommand.repeat.rawValue, "$DT @*70")
        XCTAssertEqual(SerialMessage.DateTimeResponse.dateTime(date, .valid),
                       SerialMessage.DateTimeResponse(rawValue: "$DT 20190408195123,V*41"))
    }
    
    func testFirmwareVersion() {
        
        let rawValue = "$FV 2022-10-18T22:38:36,v3.0.1*08"
        XCTAssertEqual(SerialMessage.FirmwareVersion(rawValue: rawValue)?.rawValue, rawValue)
        XCTAssertEqual(SerialMessage.FirmwareVersion(rawValue: rawValue)?.date.description, "2022-10-18 22:38:36 +0000")
        XCTAssertEqual(SerialMessage.FirmwareVersion(rawValue: rawValue)?.version, "3.0.1")
    }
    
    func testGeospatialInformation() {
        
        let rawValue = "$GN 37.8921,-122.0155,77,89,2*01"
        let information = GeospatialInformation(
            latitude: 37.8921,
            longitude: -122.0155,
            altitude: 77,
            course: 89,
            speed: 2
        )
        XCTAssertEqual(SerialMessage.GeospatialResponse(rawValue: rawValue), .information(information))
    }
}
