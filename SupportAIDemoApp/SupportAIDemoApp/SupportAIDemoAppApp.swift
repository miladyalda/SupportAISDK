import SwiftUI
import SupportAISDK

@main
struct SupportAIDemoApp: App {
    
    init() {
           SupportAI.configure(
               apiKey: "sk_test_demo123",
               actions: [
                   SupportAIAction(
                       id: "open_settings",
                       label: "Open Settings",
                       description: "Opens the app settings screen",
                       icon: "gearshape"
                   ),
                   SupportAIAction(
                       id: "show_pricing",
                       label: "View Pricing",
                       description: "Shows pricing and subscription options",
                       icon: "creditcard"
                   )
               ],
               onCustomAction: { action in
                   switch action.id {
                   case "open_settings":
                       // Navigate to settings
                       break
                   case "show_pricing":
                       // Show pricing screen
                       break
                   default:
                       break
                   }
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
