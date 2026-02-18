//
//  User.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation

struct User: Identifiable, Hashable {
    let id: String
    var name: String
    var email: String
    var phone: String
    var address: Address
    var paymentMethod: PaymentMethod?
    var preferences: UserPreferences
    
    struct UserPreferences: Hashable {
        var notificationsEnabled: Bool
        var emailUpdates: Bool
        var darkMode: Bool
    }
}

// MARK: - Payment Method
struct PaymentMethod: Hashable {
    let id: String
    let type: PaymentType
    let lastFourDigits: String
    let expiryDate: String
    
    enum PaymentType: String {
        case visa = "Visa"
        case mastercard = "Mastercard"
        case amex = "American Express"
        case applePay = "Apple Pay"
        
        var icon: String {
            switch self {
            case .visa: return "creditcard.fill"
            case .mastercard: return "creditcard.fill"
            case .amex: return "creditcard.fill"
            case .applePay: return "apple.logo"
            }
        }
    }
    
    var displayName: String {
        "\(type.rawValue) •••• \(lastFourDigits)"
    }
}

// MARK: - Mock Data
extension User {
    static let mockUser = User(
        id: "user_001",
        name: "John Doe",
        email: "john.doe@example.com",
        phone: "+1 (555) 123-4567",
        address: .mock,
        paymentMethod: PaymentMethod(
            id: "pm_001",
            type: .visa,
            lastFourDigits: "4242",
            expiryDate: "12/25"
        ),
        preferences: User.UserPreferences(
            notificationsEnabled: true,
            emailUpdates: false,
            darkMode: false
        )
    )
}
