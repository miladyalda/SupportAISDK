//
//  Ordersview.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel
    @EnvironmentObject var actionRouter: ActionRouter
    
    var body: some View {
        NavigationStack(path: $actionRouter.navigationPath) {
            Group {
                if viewModel.orders.isEmpty {
                    emptyOrdersView
                } else {
                    ordersListView
                }
            }
            .navigationTitle("Orders")
            .navigationDestination(for: AppDestination.self) { destination in
                destinationView(for: destination)
            }
            .refreshable {
                viewModel.loadOrders()
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyOrdersView: some View {
        ContentUnavailableView(
            "No Orders Yet",
            systemImage: "shippingbox",
            description: Text("Your orders will appear here")
        )
    }
    
    // MARK: - Orders List
    
    private var ordersListView: some View {
        List {
            // Stats Summary
            Section {
                HStack(spacing: 24) {
                    StatBadge(title: "Active", value: "\(viewModel.activeOrdersCount)", color: .blue)
                    StatBadge(title: "Delivered", value: "\(viewModel.deliveredOrdersCount)", color: .green)
                    StatBadge(title: "Total Spent", value: viewModel.formattedTotalSpent, color: .purple)
                }
                .padding(.vertical, 8)
            }
            
            // Filter Pills
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            title: "All",
                            isSelected: viewModel.selectedFilter == nil,
                            onTap: { viewModel.clearFilter() }
                        )
                        
                        ForEach(Order.Status.allCases, id: \.self) { status in
                            FilterChip(
                                title: status.rawValue,
                                isSelected: viewModel.selectedFilter == status,
                                onTap: { viewModel.filterByStatus(status) }
                            )
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            // Orders
            Section {
                ForEach(viewModel.filteredOrders) { order in
                    OrderRowView(order: order)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            actionRouter.navigationPath.append(AppDestination.orderDetail(orderId: order.id))
                        }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
        case .orderDetail(let orderId):
            if let order = viewModel.getOrder(byId: orderId) {
                OrderDetailView(order: order)
            }
        case .orderTracking(let orderId):
            if let order = viewModel.getOrder(byId: orderId) {
                OrderTrackingView(order: order)
            }
        default:
            EmptyView()
        }
    }
}

// MARK: - Stat Badge

struct StatBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.15))
                .cornerRadius(16)
        }
    }
}

// MARK: - Order Row

struct OrderRowView: View {
    let order: Order
    
    var body: some View {
        HStack(spacing: 16) {
            // Status Icon
            ZStack {
                Circle()
                    .fill(statusColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: order.status.icon)
                    .foregroundColor(statusColor)
            }
            
            // Order Info
            VStack(alignment: .leading, spacing: 4) {
                Text(order.id)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("\(order.items.count) item(s) • \(order.formattedDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount & Status
            VStack(alignment: .trailing, spacing: 4) {
                Text(order.formattedTotalAmount)
                    .fontWeight(.medium)
                
                Text(order.status.rawValue)
                    .font(.caption)
                    .foregroundColor(statusColor)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
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
}

#Preview {
    OrdersView(viewModel: OrdersViewModel())
        .environmentObject(ActionRouter.shared)
}
