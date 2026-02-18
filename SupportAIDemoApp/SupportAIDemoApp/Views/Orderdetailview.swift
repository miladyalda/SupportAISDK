//
//  Orderdetailview.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import SwiftUI

// MARK: - Order Detail View

struct OrderDetailView: View {
    let order: Order
    @EnvironmentObject var actionRouter: ActionRouter
    
    var body: some View {
        List {
            // Status Section
            Section {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(statusColor.opacity(0.15))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: order.status.icon)
                            .font(.title2)
                            .foregroundColor(statusColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.status.rawValue)
                            .font(.headline)
                        Text(order.formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if order.trackingNumber != nil {
                        Button {
                            actionRouter.navigationPath.append(AppDestination.orderTracking(orderId: order.id))
                        } label: {
                            Text("Track")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Items Section
            Section("Items") {
                ForEach(order.items) { item in
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                            
                            Image(systemName: iconForCategory(item.product.category))
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.product.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("Qty: \(item.quantity)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(item.formattedTotalPrice)
                            .fontWeight(.medium)
                    }
                }
            }
            
            // Shipping Address
            Section("Shipping Address") {
                VStack(alignment: .leading, spacing: 4) {
                    Text(User.mockUser.name)
                        .fontWeight(.medium)
                    Text(order.shippingAddress.formatted)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Order Summary
            Section("Summary") {
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text(order.formattedTotalAmount)
                }
                .foregroundColor(.secondary)
                
                HStack {
                    Text("Shipping")
                    Spacer()
                    Text("Free")
                        .foregroundColor(.green)
                }
                .foregroundColor(.secondary)
                
                HStack {
                    Text("Total")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(order.formattedTotalAmount)
                        .fontWeight(.bold)
                }
            }
            
            // Tracking Number
            if let tracking = order.trackingNumber {
                Section("Tracking") {
                    HStack {
                        Text(tracking)
                            .font(.system(.subheadline, design: .monospaced))
                        Spacer()
                        Button {
                            UIPasteboard.general.string = tracking
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Order \(order.id)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var statusColor: Color {
        switch order.status.color {
        case "orange": return .orange
        case "blue": return .blue
        case "purple": return .purple
        case "indigo": return .indigo
        case "green": return .green
        case "red": return .red
        default: return .gray
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

// MARK: - Order Tracking View

struct OrderTrackingView: View {
    let order: Order
    
    private let trackingSteps: [(status: Order.Status, description: String)] = [
        (.pending, "Order placed"),
        (.confirmed, "Order confirmed"),
        (.shipped, "Package shipped"),
        (.outForDelivery, "Out for delivery"),
        (.delivered, "Delivered")
    ]
    
    var currentStepIndex: Int {
        switch order.status {
        case .pending: return 0
        case .confirmed: return 1
        case .shipped: return 2
        case .outForDelivery: return 3
        case .delivered: return 4
        case .cancelled: return -1
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    if order.status == .cancelled {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                        
                        Text("Order Cancelled")
                            .font(.title2)
                            .fontWeight(.bold)
                    } else {
                        Image(systemName: order.status == .delivered ? "checkmark.circle.fill" : "shippingbox.fill")
                            .font(.system(size: 60))
                            .foregroundColor(order.status == .delivered ? .green : .blue)
                        
                        Text(order.status.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let tracking = order.trackingNumber {
                            Text(tracking)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 24)
                
                // Timeline
                if order.status != .cancelled {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(trackingSteps.enumerated()), id: \.offset) { index, step in
                            TrackingStepRow(
                                step: step.description,
                                icon: step.status.icon,
                                isCompleted: index <= currentStepIndex,
                                isCurrent: index == currentStepIndex,
                                isLast: index == trackingSteps.count - 1
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Track Order")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Tracking Step Row

struct TrackingStepRow: View {
    let step: String
    let icon: String
    let isCompleted: Bool
    let isCurrent: Bool
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline indicator
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.green : Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: isCompleted ? "checkmark" : icon)
                        .font(.caption)
                        .foregroundColor(isCompleted ? .white : .gray)
                }
                
                if !isLast {
                    Rectangle()
                        .fill(isCompleted ? Color.green : Color.gray.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            // Step text
            VStack(alignment: .leading, spacing: 4) {
                Text(step)
                    .font(.subheadline)
                    .fontWeight(isCurrent ? .semibold : .regular)
                    .foregroundColor(isCompleted ? .primary : .secondary)
                
                if isCurrent && !isLast {
                    Text("In progress")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 4)
            
            Spacer()
        }
    }
}

#Preview("Order Detail") {
    NavigationStack {
        OrderDetailView(order: Order.mockOrders[0])
            .environmentObject(ActionRouter.shared)
    }
}

#Preview("Order Tracking") {
    NavigationStack {
        OrderTrackingView(order: Order.mockOrders[0])
    }
}
