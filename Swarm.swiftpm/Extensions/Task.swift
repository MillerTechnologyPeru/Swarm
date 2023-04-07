//
//  Task.swift
//
//
//  Created by Alsey Coleman Miller on 3/25/23.
//

public extension Task where Success == Never, Failure == Never {
    
    static func sleep(timeInterval: Double) async throws {
        try await sleep(nanoseconds: UInt64(timeInterval * Double(1_000_000_000)))
    }
}
