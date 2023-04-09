//
//  UserProfile.swift
//  
//
//  Created by Alsey Coleman Miller on 4/8/23.
//

import Foundation

/// Swarm User Profile
public struct UserProfile: Equatable, Hashable, Codable, Identifiable {
    
    /// Unique identifier for the user account
    public let id: UInt32
    
    /// Username associated with the user account
    public let username: String
    
    /// Identifier for the organization that the user account belongs to
    public let organization: UInt32
    
    /// String specifying the type of billing associated with the user account
    public let billingType: BillingType
    
    /// Boolean indicating whether the user account is currently enabled or disabled
    public let isEnabled: Bool
    
    /// Boolean indicating whether the user account has been registered
    public let isRegistered: Bool
    
    /// Email address associated with the user account
    public let email: String
    
    /// Country associated with the user account
    public let country: String
    
    /// Role of the user within the organization,
    public let role: UserRole
    
    /// Boolean indicating whether two-way communication is enabled for the user account
    public let isTwoWayEnabled: Bool
    
    /// Identifier for the user application associated with the user account
    public let userApplicationId: Int
    
    /// Dictionary of feature flags for the user account
    public let featureFlags: [String: Bool]

    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case username
        case organization = "organizationId"
        case billingType
        case isEnabled = "enabled"
        case isRegistered = "registered"
        case email
        case country
        case role
        case featureFlags
        case isTwoWayEnabled = "twoWayEnabled"
        case userApplicationId
    }
}

// MARK: - Supporting Types

/// Swarm User Role
public enum UserRole: String, CaseIterable, Codable {
    
    case user           = "USER"
    case admin          = "ADMIN"
    case superAdmin     = "SUPER_ADMIN"
    case groundStation  = "GROUND_STATION"
    case tools          = "TOOLS"
}

extension UserRole: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .user:
            return "User"
        case .admin:
            return "Admin"
        case .superAdmin:
            return "Super Admin"
        case .groundStation:
            return "Ground Station"
        case .tools:
            return "Tools"
        }
    }
}

/// Swarm Billing Type
public enum BillingType: String, CaseIterable, Codable {
    
    case unbilled = "UNBILLED"
    case automaticallyBilledManuallyFinalized = "AUTOMATICALLY_BILLED_MANUALLY_FINALIZED"
    case automaticallyBilledAndFinalized = "AUTOMATICALLY_BILLED_AND_FINALIZED"
    case externallyBilled = "EXTERNALLY_BILLED"
}

extension BillingType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .unbilled:
            return "Unbilled"
        case .automaticallyBilledManuallyFinalized:
            return "Automatically Billed and Manually Finalized"
        case .automaticallyBilledAndFinalized:
            return "Automatically Billed and Finalized"
        case .externallyBilled:
            return "Externally Billed"
        }
    }
}
