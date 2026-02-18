//
//  Product.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Double
    let image: String
    let category: Category
    let description: String
    
    enum Category: String, CaseIterable {
        case shoes = "Shoes"
        case clothing = "Clothing"
        case accessories = "Accessories"
        case electronics = "Electronics"
    }
    
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
}

// MARK: - Mock Data
extension Product {
    static let mockProducts: [Product] = [
        Product(
            id: "prod_001",
            name: "Nike Air Max 90",
            price: 129.99,
            image: "nike_airmax",
            category: .shoes,
            description: "Classic Nike Air Max 90 with visible air cushioning and retro design."
        ),
        Product(
            id: "prod_002",
            name: "Adidas Ultraboost",
            price: 179.99,
            image: "adidas_ultraboost",
            category: .shoes,
            description: "Premium running shoes with responsive Boost cushioning."
        ),
        Product(
            id: "prod_003",
            name: "Classic White T-Shirt",
            price: 29.99,
            image: "white_tshirt",
            category: .clothing,
            description: "Essential cotton t-shirt in crisp white. Comfortable everyday wear."
        ),
        Product(
            id: "prod_004",
            name: "Denim Jacket",
            price: 89.99,
            image: "denim_jacket",
            category: .clothing,
            description: "Timeless denim jacket with classic fit and vintage wash."
        ),
        Product(
            id: "prod_005",
            name: "Leather Wallet",
            price: 49.99,
            image: "leather_wallet",
            category: .accessories,
            description: "Genuine leather bifold wallet with multiple card slots."
        ),
        Product(
            id: "prod_006",
            name: "Smart Watch Pro",
            price: 299.99,
            image: "smart_watch",
            category: .electronics,
            description: "Advanced smartwatch with health tracking and notifications."
        ),
        Product(
            id: "prod_007",
            name: "Wireless Earbuds",
            price: 149.99,
            image: "wireless_earbuds",
            category: .electronics,
            description: "True wireless earbuds with active noise cancellation."
        ),
        Product(
            id: "prod_008",
            name: "Canvas Backpack",
            price: 69.99,
            image: "canvas_backpack",
            category: .accessories,
            description: "Durable canvas backpack with laptop compartment."
        )
    ]
}
