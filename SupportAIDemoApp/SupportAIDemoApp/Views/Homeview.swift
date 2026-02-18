//
//  Homeview.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var cartViewModel: CartViewModel
    @EnvironmentObject var actionRouter: ActionRouter
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $actionRouter.navigationPath) {
            ScrollView {
                VStack(spacing: 20) {
                    // Categories
                    CategoryScrollView(
                        categories: viewModel.categories,
                        selectedCategory: viewModel.selectedCategory,
                        onSelect: { viewModel.selectCategory($0) }
                    )
                    
                    // Products Grid
                    ProductGridView(
                        products: viewModel.filteredProducts,
                        cartViewModel: cartViewModel
                    )
                }
                .padding(.vertical)
            }
            .navigationTitle("Shop")
            .searchable(text: $searchText, prompt: "Search products")
            .onChange(of: searchText) { _, newValue in
                viewModel.search(query: newValue)
            }
            .navigationDestination(for: AppDestination.self) { destination in
                destinationView(for: destination)
            }
            .refreshable {
                viewModel.loadProducts()
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
        case .productDetail(let productId):
            if let product = viewModel.getProduct(byId: productId) {
                ProductDetailView(product: product, cartViewModel: cartViewModel)
            }
        case .productSearch(let query):
            ProductSearchView(query: query, viewModel: viewModel, cartViewModel: cartViewModel)
        case .productCategory(let category):
            ProductCategoryView(category: category, viewModel: viewModel, cartViewModel: cartViewModel)
        default:
            EmptyView()
        }
    }
}

// MARK: - Category Scroll View

struct CategoryScrollView: View {
    let categories: [Product.Category]
    let selectedCategory: Product.Category?
    let onSelect: (Product.Category?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    onTap: { onSelect(nil) }
                )
                
                ForEach(categories, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        onTap: { onSelect(category) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.15))
                .cornerRadius(20)
        }
    }
}

// MARK: - Product Grid View

struct ProductGridView: View {
    let products: [Product]
    @ObservedObject var cartViewModel: CartViewModel
    @EnvironmentObject var actionRouter: ActionRouter
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(products) { product in
                ProductCardView(product: product, cartViewModel: cartViewModel)
                    .onTapGesture {
                        actionRouter.navigationPath.append(AppDestination.productDetail(productId: product.id))
                    }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Product Card View

struct ProductCardView: View {
    let product: Product
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product Image Placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                
                Image(systemName: iconForCategory(product.category))
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(height: 150)
            .overlay(alignment: .topTrailing) {
                if cartViewModel.containsProduct(productId: product.id) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .padding(8)
                }
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text(product.formattedPrice)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
    }
    
    private func iconForCategory(_ category: Product.Category) -> String {
        switch category {
        case .shoes: return "shoe.fill"
        case .clothing: return "tshirt.fill"
        case .accessories: return "bag.fill"
        case .electronics: return "headphones"
        }
    }
}

// MARK: - Previews

#Preview {
    HomeView(viewModel: HomeViewModel(), cartViewModel: CartViewModel())
        .environmentObject(ActionRouter.shared)
}
