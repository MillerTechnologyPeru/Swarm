//
//  WatchConnectivity.swift
//  SwarmWatchApp
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

#if canImport(WatchConnection)
import Foundation
import Combine
import WatchConnection

@available(macOS, unavailable)
@available(tvOS, unavailable)
extension WatchConnection {
    
    func updateApplicationContext(_ context: WatchApplicationContext) throws {
        try updateApplicationContext(context.dictionary)
    }
    
    func send(_ message: WatchMessage) throws {
        let data = try message.encode()
        try send(data)
    }
    
    func sendWithResponse(_ message: WatchMessage) async throws -> WatchMessage {
        let data = try message.encode()
        let response = try await sendWithResponse(data)
        return try WatchMessage(from: response)
    }
    
    func recieveWatchMessage() async throws -> WatchMessage {
        let data = try await receiveData()
        return try WatchMessage(from: data)
    }
}
#endif
