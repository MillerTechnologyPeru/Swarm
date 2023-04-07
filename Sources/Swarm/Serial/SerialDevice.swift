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
    
    public func send<T>(_ message: T) throws where T: SwarmEncodableMessage {
        try send(message.message)
    }
    
    public func recieve() throws -> SerialMessage {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
        defer { buffer.deallocate() }
        var data = Data(capacity: 256)
        
        while true {
            let bytesRead = try serialPort.readBytes(into: buffer, size: 1)
            guard bytesRead > 0 else {
                break
            }
            guard buffer[0] != "\n".utf8.first else {
                break
            }
            data.append(buffer[0])
        }
        
        guard let response = String(data: data, encoding: .utf8)
            else { throw PortError.stringsMustBeUTF8 }
        guard let message = SerialMessage(rawValue: response)
            else { throw CocoaError(.coderReadCorrupt) }
        return message
    }
    
    public func recieve<T>(_ type: T.Type) throws -> T where T: SwarmDecodableMessage {
        let message = try recieve()
        guard let decodable = T.init(message: message) else {
            throw CocoaError(.coderReadCorrupt)
        }
        return decodable
    }
}
