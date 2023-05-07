//
//  ErrorResponse.swift
//  
//
//  Created by Alsey Coleman Miller on 5/7/23.
//

import Foundation

/// Swarm Server Error Response
public struct ErrorResponse: Equatable, Hashable, Decodable {
    
    ///  A string indicating the HTTP status code or error status of the API response.
    public let status: Status
    
    /// A string providing a brief description of the error that occurred.
    public let message: String
    
    /// A string providing a more detailed message about the error, typically meant for debugging purposes.
    public let debugMessage: String?
    
    /// Date and time when the error occurred
    public let timestamp: Date
}

public extension ErrorResponse {
    
    init(from data: Data) throws {
        self = try ErrorResponse.decoder.decode(ErrorResponse.self, from: data)
    }
}

internal extension ErrorResponse {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(ErrorResponse.dateFormatter)
        return decoder
    }()
}

// MARK: - Supporting Types

public extension ErrorResponse {
    
    /// A string indicating the HTTP status code or error status of the API response.
    enum Status: String, Codable, CaseIterable {
        
        case `continue` = "CONTINUE"
        case switchingProtocols = "SWITCHING_PROTOCOLS"
        case processing = "PROCESSING"
        case checkpoint = "CHECKPOINT"
        case ok = "OK"
        case created = "CREATED"
        case accepted = "ACCEPTED"
        case nonAuthoritativeInformation = "NON_AUTHORITATIVE_INFORMATION"
        case noContent = "NO_CONTENT"
        case resetContent = "RESET_CONTENT"
        case partialContent = "PARTIAL_CONTENT"
        case multiStatus = "MULTI_STATUS"
        case alreadyReported = "ALREADY_REPORTED"
        case imUsed = "IM_USED"
        case multipleChoices = "MULTIPLE_CHOICES"
        case movedPermanently = "MOVED_PERMANENTLY"
        case found = "FOUND"
        case movedTemporarily = "MOVED_TEMPORARILY"
        case seeOther = "SEE_OTHER"
        case notModified = "NOT_MODIFIED"
        case useProxy = "USE_PROXY"
        case temporaryRedirect = "TEMPORARY_REDIRECT"
        case permanentRedirect = "PERMANENT_REDIRECT"
        case badRequest = "BAD_REQUEST"
        case unauthorized = "UNAUTHORIZED"
        case paymentRequired = "PAYMENT_REQUIRED"
        case forbidden = "FORBIDDEN"
        case notFound = "NOT_FOUND"
        case methodNotAllowed = "METHOD_NOT_ALLOWED"
        case notAcceptable = "NOT_ACCEPTABLE"
        case proxyAuthenticationRequired = "PROXY_AUTHENTICATION_REQUIRED"
        case requestTimeout = "REQUEST_TIMEOUT"
        case conflict = "CONFLICT"
        case gone = "GONE"
        case lengthRequired = "LENGTH_REQUIRED"
        case preconditionFailed = "PRECONDITION_FAILED"
        case payloadTooLarge = "PAYLOAD_TOO_LARGE"
        case requestEntityTooLarge = "REQUEST_ENTITY_TOO_LARGE"
        case uriTooLong = "URI_TOO_LONG"
        case requestUriTooLong = "REQUEST_URI_TOO_LONG"
        case unsupportedMediaType = "UNSUPPORTED_MEDIA_TYPE"
        case requestedRangeNotSatisfiable = "REQUESTED_RANGE_NOT_SATISFIABLE"
        case expectationFailed = "EXPECTATION_FAILED"
        case iAmATeapot = "I_AM_A_TEAPOT"
        case insufficientSpaceOnResource = "INSUFFICIENT_SPACE_ON_RESOURCE"
        case methodFailure = "METHOD_FAILURE"
        case destinationLocked = "DESTINATION_LOCKED"
        case unprocessableEntity = "UNPROCESSABLE_ENTITY"
        case locked = "LOCKED"
        case failedDependency = "FAILED_DEPENDENCY"
        case tooEarly = "TOO_EARLY"
        case upgradeRequired = "UPGRADE_REQUIRED"
        case preconditionRequired = "PRECONDITION_REQUIRED"
        case tooManyRequests = "TOO_MANY_REQUESTS"
        case requestHeaderFieldsTooLarge = "REQUEST_HEADER_FIELDS_TOO_LARGE"
        case unavailableForLegalReasons = "UNAVAILABLE_FOR_LEGAL_REASONS"
        case internalServerError = "INTERNAL_SERVER_ERROR"
        case notImplemented = "NOT_IMPLEMENTED"
        case badGateway = "BAD_GATEWAY"
        case serviceUnavailable = "SERVICE_UNAVAILABLE"
        case gatewayTimeout = "GATEWAY_TIMEOUT"
        case httpVersionNotSupported = "HTTP_VERSION_NOT_SUPPORTED"
        case variantAlsoNegotiates = "VARIANT_ALSO_NEGOTIATES"
        case insufficientStorage = "INSUFFICIENT_STORAGE"
        case loopDetected = "LOOP_DETECTED"
        case bandwidthLimitExceeded = "BANDWIDTH_LIMIT_EXCEEDED"
        case notExtended = "NOT_EXTENDED"
        case networkAuthenticationRequired = "NETWORK_AUTHENTICATION_REQUIRED"
    }
}
