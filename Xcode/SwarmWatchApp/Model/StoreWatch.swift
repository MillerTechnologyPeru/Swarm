//
//  StoreWatch.swift
//  SwarmWatchApp
//
//  Created by Alsey Coleman Miller on 5/8/23.
//

import Foundation
import Swarm
import WatchConnection

@available(macOS, unavailable)
@available(tvOS, unavailable)
internal extension Store {
    
    func loadWatchConnection() -> WatchConnection {
        let connection = WatchConnection.shared
        watchObserver = connection.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                self.objectWillChange.send()
            }
        // recieve
        recieveWatchMessages()
        return connection
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
internal extension Store {
    
    func sendUsernameToWatch() async {
        let connection = watchConnection
        // is supported
        guard connection.isSupported else {
            return
        }
        await activateWatchSession()
        do {
            guard try await connection.isReachable else {
                return
            }
            try await connection.send(.usernameResponse(self.username))
        }
        catch {
            log("Unable to send username. \(error)")
        }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
public extension Store {
    
    func activateWatchSession() async {
        let connection = watchConnection
        // is supported
        guard connection.isSupported else {
            return
        }
        do {
            if try await connection.state != .activated {
                try await connection.activate()
            }
        }
        catch {
            log("Unable to activate session. \(error)")
        }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(iOS, unavailable)
public extension Store {
    
    /// Attempt to request username from iOS device.
    func requestUsername() async {
        let connection = watchConnection
        // is supported
        guard connection.isSupported else {
            return
        }
        await activateWatchSession()
        do {
            guard try await connection.isReachable else {
                return
            }
            try await connection.send(.usernameRequest)
        }
        catch {
            log("Unable to request username. \(error)")
        }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
private extension Store {
    
    func recieveWatchMessages() {
        let task = Task.detached(priority: .utility) { [weak self] in
            while let connection = await self?.watchConnection {
                let message: WatchMessage
                // read respone
                do {
                    message = try await connection.recieveWatchMessage()
                }
                catch {
                    await self?.log("Unable to recieve watch message. \(error)")
                    continue
                }
                // send response
                if let response = await self?.didRecieve(message) {
                    do {
                        try await connection.send(response)
                    }
                    catch {
                        await self?.log("Unable to response to watch message. \(error)")
                    }
                }
            }
        }
        watchTasks.append(task)
    }
    
    func didRecieve(_ message: WatchMessage) -> WatchMessage? {
        log("Recieved Watch message: \(message.logDescription)")
        #if os(iOS)
        switch message {
        case .errorResponse(let error):
            log("Recieved error over Watch connection. \(error)")
            return nil
        case .usernameRequest:
            return .usernameResponse(self.username)
        case .passwordRequest:
            let password = self.username.flatMap { self[password: $0] }
            return .passwordResponse(password)
        case .passwordResponse,
            .usernameResponse:
            log("Unexpected Watch message: \(message.logDescription)")
            return nil
        }
        #elseif os(watchOS)
        switch message {
        case .errorResponse(let error):
            log("Recieved error over iOS connection. \(error)")
            return nil
        case let .usernameResponse(username):
            self.username = username
            // request password if username was provided
            return username != nil ? .passwordRequest : nil
        case let .passwordResponse(password):
            Task.detached(priority: .userInitiated) {
                if let username = await self.username {
                    await self.setPassword(password, for: username)
                    try? await self.refreshAuthorizationToken()
                }
            }
            return nil
        case .passwordRequest,
            .usernameRequest:
            log("Unexpected iOS message: \(message.logDescription)")
            return nil
        }
        #endif
    }
}

