import Foundation
import SwiftUI
import Combine
import SupportAISDK

// MARK: - App Navigation State

/// Represents all possible navigation destinations triggered by AI actions
enum AppDestination: Hashable {
    // Products
    case productList
    case productDetail(productId: String)
    case productSearch(query: String)
    case productCategory(category: Product.Category)
    
    // Cart
    case cart
    
    // Orders
    case orderList
    case orderDetail(orderId: String)
    case orderTracking(orderId: String)
    
    // Profile
    case profile
    case editAddress
    case editPayment
    case settings
}

/// Represents all actions the AI can trigger
enum AIAction: String, CaseIterable {
    // Navigation
    case showProducts = "show_products"
    case showProduct = "show_product"
    case searchProducts = "search_products"
    case showCategory = "show_category"
    case openCart = "open_cart"
    case showOrders = "show_orders"
    case showOrder = "show_order"
    case trackOrder = "track_order"
    case openProfile = "open_profile"
    case editAddress = "edit_address"
    case editPayment = "edit_payment"
    case openSettings = "open_settings"
    
    // Cart operations
    case addToCart = "add_to_cart"
    case removeFromCart = "remove_from_cart"
    case clearCart = "clear_cart"
    case applyCoupon = "apply_coupon"
    
    // Checkout
    case startCheckout = "start_checkout"
    
    // User operations
    case toggleNotifications = "toggle_notifications"
    case logout = "logout"
    
    var label: String {
        switch self {
        case .showProducts: return "Browse Products"
        case .showProduct: return "View Product"
        case .searchProducts: return "Search Products"
        case .showCategory: return "View Category"
        case .openCart: return "Open Cart"
        case .showOrders: return "View Orders"
        case .showOrder: return "View Order"
        case .trackOrder: return "Track Order"
        case .openProfile: return "Open Profile"
        case .editAddress: return "Edit Address"
        case .editPayment: return "Edit Payment"
        case .openSettings: return "Open Settings"
        case .addToCart: return "Add to Cart"
        case .removeFromCart: return "Remove from Cart"
        case .clearCart: return "Clear Cart"
        case .applyCoupon: return "Apply Coupon"
        case .startCheckout: return "Checkout"
        case .toggleNotifications: return "Toggle Notifications"
        case .logout: return "Logout"
        }
    }
    
    var description: String {
        switch self {
        case .showProducts: return "Shows all available products"
        case .showProduct: return "Shows details of a specific product"
        case .searchProducts: return "Searches products by name or keyword"
        case .showCategory: return "Shows products in a specific category"
        case .openCart: return "Opens the shopping cart"
        case .showOrders: return "Shows all user orders"
        case .showOrder: return "Shows details of a specific order"
        case .trackOrder: return "Shows tracking info for an order"
        case .openProfile: return "Opens user profile"
        case .editAddress: return "Opens address editing screen"
        case .editPayment: return "Opens payment method editing"
        case .openSettings: return "Opens app settings"
        case .addToCart: return "Adds a product to the cart"
        case .removeFromCart: return "Removes a product from the cart"
        case .clearCart: return "Removes all items from the cart"
        case .applyCoupon: return "Applies a discount coupon"
        case .startCheckout: return "Starts the checkout process"
        case .toggleNotifications: return "Toggles push notifications"
        case .logout: return "Logs out the user"
        }
    }
    
    var icon: String {
        switch self {
        case .showProducts: return "square.grid.2x2"
        case .showProduct: return "bag"
        case .searchProducts: return "magnifyingglass"
        case .showCategory: return "folder"
        case .openCart: return "cart"
        case .showOrders: return "shippingbox"
        case .showOrder: return "doc.text"
        case .trackOrder: return "location"
        case .openProfile: return "person.circle"
        case .editAddress: return "mappin.and.ellipse"
        case .editPayment: return "creditcard"
        case .openSettings: return "gearshape"
        case .addToCart: return "cart.badge.plus"
        case .removeFromCart: return "cart.badge.minus"
        case .clearCart: return "trash"
        case .applyCoupon: return "tag"
        case .startCheckout: return "bag.badge.checkmark"
        case .toggleNotifications: return "bell"
        case .logout: return "rectangle.portrait.and.arrow.right"
        }
    }
}

// MARK: - Action Router

/// Routes AI actions to app navigation and operations

@MainActor
final class ActionRouter: ObservableObject {
    static let shared = ActionRouter()
    
    // Navigation state
    @Published var selectedTab: Tab = .home
    @Published var navigationPath = NavigationPath()
    @Published var presentedSheet: AppDestination?
    
    // Toast/Alert state
    @Published var toastMessage: String?
    @Published var showLogoutAlert: Bool = false
    
    enum Tab: Int, CaseIterable {
        case home = 0
        case cart = 1
        case orders = 2
        case profile = 3
    }
    
    private init() {}
    
    // MARK: - Handle AI Action
    
    func handle(_ action: ChatAction) {
        print("🤖 AI Action: \(action.id)")
        
        Task { @MainActor in
            handleAction(
                actionId: action.id,
                data: action.data,
                cartViewModel: SharedCart.shared.viewModel
            )
        }
    }
    
    /// Processes an action received from the AI SDK
    /// - Parameters:
    ///   - actionId: The action identifier
    ///   - data: Additional data passed with the action
    ///   - cartViewModel: Reference to cart for cart operations
    func handleAction(
        actionId: String,
        data: [String: Any]?,
        cartViewModel: CartViewModel
    ) {
        guard let action = AIAction(rawValue: actionId) else {
            print("⚠️ Unknown action: \(actionId)")
            return
        }
        
        print("🤖 Handling AI action: \(action.label)")
        
        switch action {
        // Navigation actions
        case .showProducts:
            navigateToProducts()
            
        case .showProduct:
            if let productId = data?["product_id"] as? String {
                navigateToProduct(productId: productId)
            }
            
        case .searchProducts:
            if let query = data?["query"] as? String {
                navigateToSearch(query: query)
            }
            
        case .showCategory:
            if let categoryName = data?["category"] as? String,
               let category = Product.Category(rawValue: categoryName) {
                navigateToCategory(category: category)
            }
            
        case .openCart:
            navigateToCart()
            
        case .showOrders:
            navigateToOrders()
            
        case .showOrder:
            if let orderId = data?["order_id"] as? String {
                navigateToOrder(orderId: orderId)
            }
            
        case .trackOrder:
            if let orderId = data?["order_id"] as? String {
                navigateToTracking(orderId: orderId)
            }
            
        case .openProfile:
            navigateToProfile()
            
        case .editAddress:
            presentedSheet = .editAddress
            
        case .editPayment:
            presentedSheet = .editPayment
            
        case .openSettings:
            navigateToProfile()
            
        // Cart operations
        case .addToCart:
            if let productId = data?["product_id"] as? String,
               let product = MockDataService.shared.getProduct(byId: productId) {
                let quantity = data?["quantity"] as? Int ?? 1
                cartViewModel.addToCart(product: product, quantity: quantity)
                showToast("Added \(product.name) to cart")
            }
            
        case .removeFromCart:
            if let productId = data?["product_id"] as? String {
                cartViewModel.removeFromCart(productId: productId)
                showToast("Removed item from cart")
            }
            
        case .clearCart:
            cartViewModel.clearCart()
            showToast("Cart cleared")
            
        case .applyCoupon:
            if let code = data?["code"] as? String {
                // In a real app, validate the coupon
                showToast("Coupon '\(code)' applied!")
            }
            
        case .startCheckout:
            navigateToCart()
            // Could present checkout sheet
            
        // User operations
        case .toggleNotifications:
            // Would toggle in ProfileViewModel
            showToast("Notifications toggled")
            
        case .logout:
            showLogoutAlert = true
        }
    }
    
    // MARK: - Navigation Helpers
    
    private func navigateToProducts() {
        selectedTab = .home
        navigationPath = NavigationPath()
    }
    
    private func navigateToProduct(productId: String) {
        selectedTab = .home
        navigationPath = NavigationPath()
        navigationPath.append(AppDestination.productDetail(productId: productId))
    }
    
    private func navigateToSearch(query: String) {
        selectedTab = .home
        navigationPath = NavigationPath()
        navigationPath.append(AppDestination.productSearch(query: query))
    }
    
    private func navigateToCategory(category: Product.Category) {
        selectedTab = .home
        navigationPath = NavigationPath()
        navigationPath.append(AppDestination.productCategory(category: category))
    }
    
    private func navigateToCart() {
        selectedTab = .cart
        navigationPath = NavigationPath()
    }
    
    private func navigateToOrders() {
        selectedTab = .orders
        navigationPath = NavigationPath()
    }
    
    private func navigateToOrder(orderId: String) {
        selectedTab = .orders
        navigationPath = NavigationPath()
        navigationPath.append(AppDestination.orderDetail(orderId: orderId))
    }
    
    private func navigateToTracking(orderId: String) {
        selectedTab = .orders
        navigationPath = NavigationPath()
        navigationPath.append(AppDestination.orderTracking(orderId: orderId))
    }
    
    private func navigateToProfile() {
        selectedTab = .profile
        navigationPath = NavigationPath()
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
        
        // Auto-dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            if self?.toastMessage == message {
                self?.toastMessage = nil
            }
        }
    }
}
