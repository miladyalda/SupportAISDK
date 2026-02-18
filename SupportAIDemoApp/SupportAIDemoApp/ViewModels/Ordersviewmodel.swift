//
//  Ordersviewmodel.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var selectedFilter: Order.Status?
    @Published var isLoading: Bool = false
    
    private let dataService = MockDataService.shared
    
    var filteredOrders: [Order] {
        guard let filter = selectedFilter else {
            return orders.sorted { $0.date > $1.date }
        }
        return orders.filter { $0.status == filter }.sorted { $0.date > $1.date }
    }
    
    init() {
        loadOrders()
    }
    
    func loadOrders() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            self.orders = self.dataService.getAllOrders()
            self.isLoading = false
        }
    }
    
    func getOrder(byId id: String) -> Order? {
        orders.first { $0.id == id }
    }
    
    func filterByStatus(_ status: Order.Status?) {
        selectedFilter = status
    }
    
    func clearFilter() {
        selectedFilter = nil
    }
    
    // MARK: - Order Statistics
    
    var activeOrdersCount: Int {
        orders.filter { $0.status != .delivered && $0.status != .cancelled }.count
    }
    
    var deliveredOrdersCount: Int {
        orders.filter { $0.status == .delivered }.count
    }
    
    var totalSpent: Double {
        orders.filter { $0.status == .delivered }.reduce(0) { $0 + $1.totalAmount }
    }
    
    var formattedTotalSpent: String {
        String(format: "$%.2f", totalSpent)
    }
}
