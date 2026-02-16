import SwiftUI
import SupportAISDK

@main
struct SupportAIDemoApp: App {
    
    init() {
        SupportAI.configure(
            apiKey: "sk_test_demo123",
            userId: "demo_user_123",
            theme: .custom(primaryColor: "#007AFF"),
            onCustomAction: { action in
                // Handle actions
            }
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withSupportAIChat()  // No apiKey here, already configured
        }
    }
}
