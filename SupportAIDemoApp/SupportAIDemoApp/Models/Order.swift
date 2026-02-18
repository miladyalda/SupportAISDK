//
//  Order.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation

struct Order: Identifiable, Hashable {
    let id: String
    let items: [CartItem]
    let status: Status
    let date: Date
    let trackingNumber: String?
    let shippingAddress: Address
    
    enum Status: String, CaseIterable {
        case pending = "Pending"
        case confirmed = "Confirmed"
        case shipped = "Shipped"
        case outForDelivery = "Out for Delivery"
        case delivered = "Delivered"
        case cancelled = "Cancelled"
        
        var icon: String {
            switch self {
            case .pending: return "clock"
            case .confirmed: return "checkmark.circle"
            case .shipped: return "shippingbox"
            case .outForDelivery: return "truck.box"
            case .delivered: return "checkmark.seal.fill"
            case .cancelled: return "xmark.circle"
            }
        }
        
        var color: String {
            switch self {
            case .pending: return "orange"
            case .confirmed: return "blue"
            case .shipped: return "purple"
            case .outForDelivery: return "indigo"
            case .delivered: return "green"
            case .cancelled: return "red"
            }
        }
    }
    
    var totalAmount: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var formattedTotalAmount: String {
        String(format: "$%.2f", totalAmount)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Address
struct Address: Hashable {
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    
    var formatted: String {
        "\(street)\n\(city), \(state) \(zipCode)\n\(country)"
    }
    
    static let mock = Address(
        street: "123 Main Street",
        city: "San Francisco",
        state: "CA",
        zipCode: "94102",
        country: "United States"
    )
}

// MARK: - Mock Data
extension Order {
    static let mockOrders: [Order] = [
        Order(
            id: "ORD-001",
            items: [
                CartItem(product: Product.mockProducts[0], quantity: 1),
                CartItem(product: Product.mockProducts[2], quantity: 2)
            ],
            status: .shipped,
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            trackingNumber: "1Z999AA10123456784",
            shippingAddress: .mock
        ),
        Order(
            id: "ORD-002",
            items: [
                CartItem(product: Product.mockProducts[5], quantity: 1)
            ],
            status: .delivered,
            date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            trackingNumber: "1Z999AA10123456785",
            shippingAddress: .mock
        ),
        Order(
            id: "ORD-003",
            items: [
                CartItem(product: Product.mockProducts[6], quantity: 1),
                CartItem(product: Product.mockProducts[4], quantity: 1)
            ],
            status: .pending,
            date: Date(),
            trackingNumber: nil,
            shippingAddress: .mock
        )
    ]
}
