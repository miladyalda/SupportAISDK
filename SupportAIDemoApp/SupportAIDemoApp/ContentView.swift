import SwiftUI
import SupportAISDK

struct ContentView: View {
    
    @State private var lastAction: String = "No action yet"
    @State private var actionCount: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "message.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("SupportAI SDK Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Tap the floating button to start chatting")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Action display card
                VStack(spacing: 8) {
                    Text("Last Action Received")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "bolt.circle.fill")
                            .foregroundColor(.orange)
                        Text(lastAction)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    
                    if actionCount > 0 {
                        Text("Total actions: \(actionCount)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Control buttons
                VStack(spacing: 12) {
                    Button {
                        SupportAI.expand()
                    } label: {
                        Label("Open Chat", systemImage: "message.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            SupportAI.hide()
                        } label: {
                            Label("Hide", systemImage: "eye.slash")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                        
                        Button {
                            SupportAI.show()
                        } label: {
                            Label("Show", systemImage: "eye")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                    }
                    
                    Button {
                        SupportAI.startNewChat()
                        lastAction = "Chat reset"
                    } label: {
                        Label("New Chat", systemImage: "plus.message")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 120)
            }
            .navigationTitle("Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            setupActionHandler()
        }
    }
    
    private func setupActionHandler() {
        SupportAI.configure(
            apiKey: "sk_test_demo123",
            userId: "demo_user_123",
            theme: .custom(primaryColor: "#007AFF"),
            welcomeMessage: "Hi! 👋 How can I help you today?",
            headerTitle: "Support",
            headerSubtitle: "We typically reply instantly",
            onCustomAction: { action in
                // Update UI
                actionCount += 1
                lastAction = "\(action.label) (\(action.id))"
                
                print("🔘 Action tapped!")
                print("   ID: \(action.id)")
                print("   Label: \(action.label)")
                print("   Icon: \(action.icon ?? "none")")
                print("   Data: \(action.data ?? [:])")
                
                // Handle specific actions
                switch action.id {
                case "open_esims":
                    lastAction = "📱 Open eSIMs tab"
                case "create_ticket":
                    lastAction = "🎫 Create support ticket"
                case "open_settings":
                    lastAction = "⚙️ Open settings"
                default:
                    lastAction = "❓ \(action.label)"
                }
            }
        )
    }
}

#Preview {
    ContentView()
}
