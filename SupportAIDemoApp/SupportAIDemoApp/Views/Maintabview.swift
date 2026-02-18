//
//  Maintabview.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var actionRouter = ActionRouter.shared
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var ordersViewModel = OrdersViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        TabView(selection: $actionRouter.selectedTab) {
            HomeView(viewModel: homeViewModel, cartViewModel: cartViewModel)
                .tabItem {
                    Label("Shop", systemImage: "bag")
                }
                .tag(ActionRouter.Tab.home)
            
            CartView(viewModel: cartViewModel)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .badge(cartViewModel.itemCount > 0 ? "\(cartViewModel.itemCount)" : nil)
                .tag(ActionRouter.Tab.cart)
            
            OrdersView(viewModel: ordersViewModel)
                .tabItem {
                    Label("Orders", systemImage: "shippingbox")
                }
                .tag(ActionRouter.Tab.orders)
            
            ProfileView(viewModel: profileViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(ActionRouter.Tab.profile)
        }
        .overlay(alignment: .bottom) {
            if let message = actionRouter.toastMessage {
                ToastView(message: message)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 100)
            }
        }
        .animation(.easeInOut, value: actionRouter.toastMessage)
        .alert("Logout", isPresented: $actionRouter.showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) {
                profileViewModel.logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
        .environmentObject(actionRouter)
        .environmentObject(cartViewModel)
    }
}

// MARK: - Toast View

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.8))
            .cornerRadius(25)
            .shadow(radius: 10)
    }
}

#Preview {
    MainTabView()
}
