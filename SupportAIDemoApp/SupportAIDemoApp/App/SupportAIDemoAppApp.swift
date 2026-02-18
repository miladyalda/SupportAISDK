import SwiftUI
import SupportAISDK

@main
struct SupportAIDemoApp: App {
    
    init() {
        SupportAIConfig.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .withSupportAIChat()
        }
    }
}

// MARK: - SupportAI Configuration

enum SupportAIConfig {
    
    static func setup() {
        SupportAI.configure(
            apiKey: "sk_test_demo123",
            userId: "demo_user_123",
            actions: allActions,
            theme: .custom(primaryColor: "#007AFF"),
            welcomeMessage: "Hi! 👋 I'm your shopping assistant. I can help you browse products, manage your cart, track orders, and more. What would you like to do?",
            headerTitle: "Shop Assistant",
            headerSubtitle: "Ask me anything",
            onCustomAction: { action in
                ActionRouter.shared.handle(action)
            }
        )
    }
    
    // MARK: - Actions
    
    private static var allActions: [SupportAIAction] {
        navigationActions + cartActions + userActions
    }
    
    private static var navigationActions: [SupportAIAction] {
        [
            .init(id: "show_products", label: "Browse Products", description: "Shows all available products in the shop", icon: "square.grid.2x2"),
            .init(id: "show_product", label: "View Product", description: "Shows details of a specific product. Requires product_id in data.", icon: "bag"),
            .init(id: "search_products", label: "Search Products", description: "Searches products by name or keyword. Requires query in data.", icon: "magnifyingglass"),
            .init(id: "show_category", label: "View Category", description: "Shows products in a category (Shoes, Clothing, Accessories, Electronics). Requires category in data.", icon: "folder"),
            .init(id: "open_cart", label: "Open Cart", description: "Opens the shopping cart to view items", icon: "cart"),
            .init(id: "show_orders", label: "View Orders", description: "Shows all user orders and their status", icon: "shippingbox"),
            .init(id: "show_order", label: "View Order", description: "Shows details of a specific order. Requires order_id in data.", icon: "doc.text"),
            .init(id: "track_order", label: "Track Order", description: "Shows tracking information for an order. Requires order_id in data.", icon: "location"),
            .init(id: "open_profile", label: "Open Profile", description: "Opens the user profile screen", icon: "person.circle"),
            .init(id: "edit_address", label: "Edit Address", description: "Opens the shipping address editing screen", icon: "mappin.and.ellipse"),
            .init(id: "edit_payment", label: "Edit Payment", description: "Opens the payment method editing screen", icon: "creditcard"),
            .init(id: "open_settings", label: "Open Settings", description: "Opens the app settings screen", icon: "gearshape")
        ]
    }
    
    private static var cartActions: [SupportAIAction] {
        [
            .init(id: "add_to_cart", label: "Add to Cart", description: "Adds a product to the cart. Requires product_id in data. Optional: quantity (default 1).", icon: "cart.badge.plus"),
            .init(id: "remove_from_cart", label: "Remove from Cart", description: "Removes a product from the cart. Requires product_id in data.", icon: "cart.badge.minus"),
            .init(id: "clear_cart", label: "Clear Cart", description: "Removes all items from the shopping cart", icon: "trash"),
            .init(id: "apply_coupon", label: "Apply Coupon", description: "Applies a discount coupon. Requires code in data. Valid codes: SAVE10, SAVE20, WELCOME.", icon: "tag"),
            .init(id: "start_checkout", label: "Start Checkout", description: "Opens the cart and starts the checkout process", icon: "bag.badge.checkmark")
        ]
    }
    
    private static var userActions: [SupportAIAction] {
        [
            .init(id: "toggle_notifications", label: "Toggle Notifications", description: "Toggles push notifications on or off", icon: "bell"),
            .init(id: "logout", label: "Logout", description: "Logs the user out of the app", icon: "rectangle.portrait.and.arrow.right")
        ]
    }
}
