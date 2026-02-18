//
//  Productsearchview.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import SwiftUI

// MARK: - Product Search View

struct ProductSearchView: View {
    let query: String
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var cartViewModel: CartViewModel
    
    var searchResults: [Product] {
        viewModel.products.filter {
            $0.name.lowercased().contains(query.lowercased()) ||
            $0.description.lowercased().contains(query.lowercased())
        }
    }
    
    var body: some View {
        Group {
            if searchResults.isEmpty {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "magnifyingglass",
                    description: Text("No products found for '\(query)'")
                )
            } else {
                ScrollView {
                    ProductGridView(products: searchResults, cartViewModel: cartViewModel)
                        .padding(.vertical)
                }
            }
        }
        .navigationTitle("Search: \(query)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Product Category View

struct ProductCategoryView: View {
    let category: Product.Category
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var cartViewModel: CartViewModel
    
    var categoryProducts: [Product] {
        viewModel.products.filter { $0.category == category }
    }
    
    var body: some View {
        Group {
            if categoryProducts.isEmpty {
                ContentUnavailableView(
                    "No Products",
                    systemImage: "bag",
                    description: Text("No products in \(category.rawValue)")
                )
            } else {
                ScrollView {
                    ProductGridView(products: categoryProducts, cartViewModel: cartViewModel)
                        .padding(.vertical)
                }
            }
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Search") {
    NavigationStack {
        ProductSearchView(
            query: "Nike",
            viewModel: HomeViewModel(),
            cartViewModel: CartViewModel()
        )
        .environmentObject(ActionRouter.shared)
    }
}

#Preview("Category") {
    NavigationStack {
        ProductCategoryView(
            category: .shoes,
            viewModel: HomeViewModel(),
            cartViewModel: CartViewModel()
        )
        .environmentObject(ActionRouter.shared)
    }
}
