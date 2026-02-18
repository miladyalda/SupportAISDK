//
//  CartItem.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation

struct CartItem: Identifiable, Hashable {
    let id: String
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        product.price * Double(quantity)
    }
    
    var formattedTotalPrice: String {
        String(format: "$%.2f", totalPrice)
    }
    
    init(product: Product, quantity: Int = 1) {
        self.id = "cart_\(product.id)"
        self.product = product
        self.quantity = quantity
    }
}
