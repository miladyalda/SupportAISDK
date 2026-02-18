//
//  Productdetailview.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @ObservedObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var quantity = 1
    @State private var showAddedToCart = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Product Image
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                    
                    Image(systemName: iconForCategory(product.category))
                        .font(.system(size: 80))
                        .foregroundColor(.gray.opacity(0.4))
                }
                .frame(height: 300)
                .padding(.horizontal)
                
                // Product Info
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.category.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(product.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(product.formattedPrice)
                            .font(.title2)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Quantity Selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quantity")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            Button {
                                if quantity > 1 { quantity -= 1 }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(quantity > 1 ? .blue : .gray)
                            }
                            .disabled(quantity <= 1)
                            
                            Text("\(quantity)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(minWidth: 40)
                            
                            Button {
                                quantity += 1
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                if showAddedToCart {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Added to cart!")
                            .fontWeight(.medium)
                    }
                    .transition(.opacity)
                }
                
                Button {
                    addToCart()
                } label: {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Add to Cart")
                        Spacer()
                        Text(String(format: "$%.2f", product.price * Double(quantity)))
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(16)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
    
    private func addToCart() {
        cartViewModel.addToCart(product: product, quantity: quantity)
        
        withAnimation {
            showAddedToCart = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showAddedToCart = false
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

#Preview {
    NavigationStack {
        ProductDetailView(
            product: Product.mockProducts[0],
            cartViewModel: CartViewModel()
        )
    }
}
