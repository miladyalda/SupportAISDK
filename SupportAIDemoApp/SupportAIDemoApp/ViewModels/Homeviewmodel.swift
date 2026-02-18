//
//  Homeviewmodel.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var categories: [Product.Category] = Product.Category.allCases
    @Published var selectedCategory: Product.Category?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let dataService = MockDataService.shared
    
    init() {
        loadProducts()
    }
    
    func loadProducts() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            self.products = self.dataService.getAllProducts()
            self.applyFilters()
            self.isLoading = false
        }
    }
    
    func selectCategory(_ category: Product.Category?) {
        selectedCategory = category
        applyFilters()
    }
    
    func search(query: String) {
        searchText = query
        applyFilters()
    }
    
    func clearFilters() {
        selectedCategory = nil
        searchText = ""
        applyFilters()
    }
    
    private func applyFilters() {
        var result = products
        
        // Apply category filter
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(query) ||
                $0.description.lowercased().contains(query)
            }
        }
        
        filteredProducts = result
    }
    
    func getProduct(byId id: String) -> Product? {
        products.first { $0.id == id }
    }
}
