//
//  URL.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

internal extension URL {
    
    func appending(_ queryItems: URLQueryItem?...) -> URL {
        let items = queryItems.compactMap({ $0 })
        #if canImport(FoundationNetworking)
        return _appending(items)
        #else
        if #available(macOS 13, iOS 16, *) {
            return appending(queryItems: items)
        } else {
            return _appending(items)
        }
        #endif
    }
}

private extension URL {
    
    func _appending(_ queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(string: self.absoluteString)!
        components.queryItems = queryItems
        return components.url!
    }
}
