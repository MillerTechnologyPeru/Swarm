//
//  SerialDevice.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

import Foundation

public final class SerialDevice {
    
    internal let serialPort: SerialPort
    
    public init(path: String) throws {
        self.serialPort = SerialPort(path: path)
        try serialPort.openPort()
        serialPort.setSettings(
            receiveRate: .baud115200,
            transmitRate: .baud115200,
            minimumBytesToRead: 0,
            timeout: 3,
            parityType: .none,
            dataBitsSize: .bits8
        )
    }
    
    public func send(_ message: SerialMessage) throws {
        let writtenBytes = try serialPort.writeString(message.rawValue + "\u{000D}\u{000A}")
        assert(writtenBytes == message.description.utf8.count + 2)
    }
    
    
}
