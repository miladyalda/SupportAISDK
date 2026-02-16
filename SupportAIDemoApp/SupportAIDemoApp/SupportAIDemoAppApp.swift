import SwiftUI
import SupportAISDK

import SwiftUI
import SupportAISDK

@main
struct SupportAIDemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withSupportAIChat(apiKey: "sk_test_demo123")
        }
    }
}
