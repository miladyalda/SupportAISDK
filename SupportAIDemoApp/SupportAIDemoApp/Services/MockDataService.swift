//
//  MockDataService.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation

/// Service providing mock data for the demo app
final class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    // MARK: - Products
    
    func getAllProducts() -> [Product] {
        Product.mockProducts
    }
    
    func getProduct(byId id: String) -> Product? {
        Product.mockProducts.first { $0.id == id }
    }
    
    func getProducts(byCategory category: Product.Category) -> [Product] {
        Product.mockProducts.filter { $0.category == category }
    }
    
    func searchProducts(query: String) -> [Product] {
        let lowercasedQuery = query.lowercased()
        return Product.mockProducts.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.description.lowercased().contains(lowercasedQuery) ||
            $0.category.rawValue.lowercased().contains(lowercasedQuery)
        }
    }
    
    // MARK: - Orders
    
    func getAllOrders() -> [Order] {
        Order.mockOrders
    }
    
    func getOrder(byId id: String) -> Order? {
        Order.mockOrders.first { $0.id == id }
    }
    
    func getOrders(byStatus status: Order.Status) -> [Order] {
        Order.mockOrders.filter { $0.status == status }
    }
    
    // MARK: - User
    
    func getCurrentUser() -> User {
        User.mockUser
    }
}
