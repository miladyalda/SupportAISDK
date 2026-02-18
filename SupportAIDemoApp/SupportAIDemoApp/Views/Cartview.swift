//
//  Cartview.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: CartViewModel
    @State private var couponCode = ""
    @State private var showCouponError = false
    @State private var showCheckoutSheet = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isEmpty {
                    emptyCartView
                } else {
                    cartContentView
                }
            }
            .navigationTitle("Cart")
            .sheet(isPresented: $showCheckoutSheet) {
                CheckoutView(cartViewModel: viewModel)
            }
        }
    }
    
    // MARK: - Empty Cart
    
    private var emptyCartView: some View {
        ContentUnavailableView(
            "Your Cart is Empty",
            systemImage: "cart",
            description: Text("Add items to get started")
        )
    }
    
    // MARK: - Cart Content
    
    private var cartContentView: some View {
        VStack(spacing: 0) {
            // Cart Items
            List {
                ForEach(viewModel.items) { item in
                    CartItemRow(
                        item: item,
                        onIncrement: { viewModel.incrementQuantity(productId: item.product.id) },
                        onDecrement: { viewModel.decrementQuantity(productId: item.product.id) },
                        onRemove: { viewModel.removeFromCart(productId: item.product.id) }
                    )
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.removeFromCart(productId: viewModel.items[index].product.id)
                    }
                }
                
                // Coupon Section
                Section {
                    couponSection
                }
            }
            .listStyle(.insetGrouped)
            
            // Summary & Checkout
            checkoutSummary
        }
    }
    
    // MARK: - Coupon Section
    
    private var couponSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let coupon = viewModel.appliedCoupon {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.green)
                    Text(coupon)
                        .fontWeight(.medium)
                    Spacer()
                    Text("-\(Int(viewModel.discountPercentage * 100))%")
                        .foregroundColor(.green)
                    Button {
                        viewModel.removeCoupon()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                HStack {
                    TextField("Coupon code", text: $couponCode)
                        .textInputAutocapitalization(.characters)
                    
                    Button("Apply") {
                        if viewModel.applyCoupon(code: couponCode) {
                            couponCode = ""
                            showCouponError = false
                        } else {
                            showCouponError = true
                        }
                    }
                    .disabled(couponCode.isEmpty)
                }
                
                if showCouponError {
                    Text("Invalid coupon code")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    // MARK: - Checkout Summary
    
    private var checkoutSummary: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text(viewModel.formattedSubtotal)
                }
                .foregroundColor(.secondary)
                
                if viewModel.discountPercentage > 0 {
                    HStack {
                        Text("Discount")
                        Spacer()
                        Text(viewModel.formattedDiscount)
                            .foregroundColor(.green)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(viewModel.formattedTotal)
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            
            Button {
                showCheckoutSheet = true
            } label: {
                Text("Checkout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
    }
}

// MARK: - Cart Item Row

struct CartItemRow: View {
    let item: CartItem
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Image Placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                
                Image(systemName: iconForCategory(item.product.category))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(width: 60, height: 60)
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text(item.product.formattedPrice)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Quantity Controls
            VStack(alignment: .trailing, spacing: 8) {
                Text(item.formattedTotalPrice)
                    .fontWeight(.semibold)
                
                HStack(spacing: 12) {
                    Button(action: onDecrement) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.borderless)
                    
                    Text("\(item.quantity)")
                        .font(.subheadline)
                        .frame(minWidth: 20)
                    
                    Button(action: onIncrement) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .padding(.vertical, 4)
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

// MARK: - Checkout View

struct CheckoutView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var orderPlaced = false
    
    var body: some View {
        NavigationStack {
            if orderPlaced {
                orderConfirmationView
            } else {
                checkoutFormView
            }
        }
    }
    
    private var checkoutFormView: some View {
        List {
            Section("Shipping Address") {
                VStack(alignment: .leading, spacing: 4) {
                    Text(User.mockUser.name)
                        .fontWeight(.medium)
                    Text(User.mockUser.address.formatted)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Payment") {
                if let payment = User.mockUser.paymentMethod {
                    HStack {
                        Image(systemName: payment.type.icon)
                        Text(payment.displayName)
                    }
                }
            }
            
            Section("Order Summary") {
                ForEach(cartViewModel.items) { item in
                    HStack {
                        Text("\(item.quantity)x")
                            .foregroundColor(.secondary)
                        Text(item.product.name)
                        Spacer()
                        Text(item.formattedTotalPrice)
                    }
                    .font(.subheadline)
                }
                
                HStack {
                    Text("Total")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(cartViewModel.formattedTotal)
                        .fontWeight(.bold)
                }
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                placeOrder()
            } label: {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Place Order")
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(16)
            }
            .disabled(isProcessing)
            .padding()
        }
    }
    
    private var orderConfirmationView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Order Placed!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Thank you for your purchase.\nYou'll receive a confirmation email shortly.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
    
    private func placeOrder() {
        isProcessing = true
        
        // Simulate order processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            orderPlaced = true
            cartViewModel.clearCart()
        }
    }
}

#Preview {
    let cart = CartViewModel()
    cart.addToCart(product: Product.mockProducts[0])
    cart.addToCart(product: Product.mockProducts[2], quantity: 2)
    return CartView(viewModel: cart)
}
