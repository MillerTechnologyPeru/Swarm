//
//  SerialDevice.swift
//  
//
//  Created by Alsey Coleman Miller on 4/6/23.
//

#if canImport(Socket)
import Foundation
import Socket

public final class SerialDevice {
    
    internal let serialPort: SerialPort
    
    public init(path: String) async throws {
        self.serialPort = try SerialPort(path: path)
        try await serialPort.openPort()
        await serialPort.setSettings(
            receiveRate: .baud115200,
            transmitRate: .baud115200,
            minimumBytesToRead: 0,
            timeout: 3,
            parityType: .none,
            dataBitsSize: .bits8
        )
    }
    
    public func send(_ message: SerialMessage) async throws {
        let writtenBytes = try await serialPort.writeString(message.rawValue + "\u{000D}\u{000A}")
        assert(writtenBytes == message.description.utf8.count + 2)
    }
    
    public func send<T>(_ message: T) async throws where T: SwarmEncodableMessage {
        try await send(message.message)
    }
    
    public func recieve() async throws -> String {
        var data = Data(capacity: 256)
        
        while true {
            let bytesRead = try await serialPort.readData(ofLength: 1)
            guard bytesRead.count > 0 else {
                break
            }
            guard bytesRead[0] != "\n".utf8.first else {
                break
            }
            data.append(bytesRead[0])
        }
        
        guard let response = String(data: data, encoding: .utf8)
            else { throw SerialDevice.Error.invalidData(data) }
        
        return response
    }
    
    @available(macOS 13.0, iOS 16, watchOS 9.0, tvOS 16, *)
    public func recieveMessage() async throws -> SerialMessage {
        var data = Data(capacity: 256)
        
        while true {
            let bytesRead = try await serialPort.readData(ofLength: 1)
            guard bytesRead.count > 0 else {
                break
            }
            guard bytesRead[0] != "\n".utf8.first else {
                break
            }
            data.append(bytesRead[0])
        }
        
        guard let response = String(data: data, encoding: .utf8),
            let message = SerialMessage(rawValue: response)
            else { throw SerialDevice.Error.invalidData(data) }
        
        return message
    }
    
    @available(macOS 13.0, iOS 16, watchOS 9.0, tvOS 16, *)
    public func recieve<T>(_ type: T.Type) async throws -> T where T: SwarmDecodableMessage {
        let message = try await recieveMessage()
        guard let decodable = T.init(message: message) else {
            throw SerialDevice.Error.invalidData(Data(message.rawValue.utf8))
        }
        return decodable
    }
}

public extension SerialDevice {
    
    enum Error: Swift.Error {
        
        case failedToOpen
        case invalidPath
        case mustReceiveOrTransmit
        case mustBeOpen
        case unableToConvertByteToCharacter
        case deviceNotConnected
        case invalidData(Data)
    }
}

#endif
