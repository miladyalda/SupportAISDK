//
//  Cartviewmodel.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var appliedCoupon: String?
    @Published var discountPercentage: Double = 0
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var discount: Double {
        subtotal * discountPercentage
    }
    
    var total: Double {
        subtotal - discount
    }
    
    var formattedSubtotal: String {
        String(format: "$%.2f", subtotal)
    }
    
    var formattedDiscount: String {
        String(format: "-$%.2f", discount)
    }
    
    var formattedTotal: String {
        String(format: "$%.2f", total)
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    // MARK: - Cart Operations
    
    func addToCart(product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func removeFromCart(productId: String) {
        items.removeAll { $0.product.id == productId }
    }
    
    func updateQuantity(productId: String, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == productId }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = quantity
            }
        }
    }
    
    func incrementQuantity(productId: String) {
        if let index = items.firstIndex(where: { $0.product.id == productId }) {
            items[index].quantity += 1
        }
    }
    
    func decrementQuantity(productId: String) {
        if let index = items.firstIndex(where: { $0.product.id == productId }) {
            if items[index].quantity > 1 {
                items[index].quantity -= 1
            } else {
                items.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
        appliedCoupon = nil
        discountPercentage = 0
    }
    
    func applyCoupon(code: String) -> Bool {
        // Mock coupon validation
        let validCoupons: [String: Double] = [
            "SAVE10": 0.10,
            "SAVE20": 0.20,
            "WELCOME": 0.15
        ]
        
        if let discount = validCoupons[code.uppercased()] {
            appliedCoupon = code.uppercased()
            discountPercentage = discount
            return true
        }
        return false
    }
    
    func removeCoupon() {
        appliedCoupon = nil
        discountPercentage = 0
    }
    
    func containsProduct(productId: String) -> Bool {
        items.contains { $0.product.id == productId }
    }
    
    func quantity(for productId: String) -> Int {
        items.first { $0.product.id == productId }?.quantity ?? 0
    }
}
