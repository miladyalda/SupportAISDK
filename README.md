```markdown
# SupportAI SDK

A plug-and-play AI-powered customer support chat SDK for iOS apps. Features a floating chat button with smooth morphing animations, API key authentication, and full customization.

![iOS 15+](https://img.shields.io/badge/iOS-15%2B-blue)
![Swift 5.7+](https://img.shields.io/badge/Swift-5.7%2B-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- 🔑 **Simple API Key Auth** — Just add your API key, like Stripe
- 🎯 **Floating Chat Button** — Draggable, always accessible
- 💬 **Full Chat Interface** — Smooth morphing animation
- 🎨 **Fully Customizable** — Colors, text, icons
- 🔘 **Built-in Actions** — URL, copy, call, email, share handled automatically
- 🧩 **Custom Actions** — App-specific actions via callback
- 📱 **iOS 15+** — Wide compatibility

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/miladyalda/SupportAISDK.git", from: "1.0.0")
]
```

Or in Xcode:
1. `File → Add Package Dependencies`
2. Enter: `https://github.com/miladyalda/SupportAISDK.git`

## Quick Start

### 1. Get Your API Key

Get an API key from your backend dashboard. Keys look like: `sk_live_abc123...`

### 2. Configure at App Launch

```swift
import SupportAISDK

@main
struct MyApp: App {
    
    init() {
        SupportAI.configure(
            apiKey: "sk_live_your_api_key_here",
            theme: .custom(primaryColor: "#007AFF"),
            headerTitle: "Support",
            headerSubtitle: "We're here to help",
            onCustomAction: { action in
                switch action.id {
                case "open_esims":
                    // Navigate to eSIMs screen
                case "create_ticket":
                    // Show ticket form
                default:
                    break
                }
            }
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withSupportAIChat(apiKey: "sk_live_your_api_key_here")
        }
    }
}
```

### 3. That's it! 🎉

A floating chat button will appear on all screens.

## Configuration

### Simple Configuration

```swift
SupportAI.configure(
    apiKey: "sk_live_...",
    onCustomAction: { action in
        // Handle custom actions
    }
)
```

### Full Configuration

```swift
let config = SupportAIConfiguration(
    apiKey: "sk_live_...",
    apiEndpoint: "https://your-api.com/v1/chat",  // Optional custom endpoint
    userId: "user_123",                            // Optional user tracking
    theme: .custom(primaryColor: "#FF5722"),
    welcomeMessage: "Hi! 👋 How can I help?",
    inputPlaceholder: "Type a message...",
    headerTitle: "Support",
    headerSubtitle: "We typically reply instantly",
    allowButtonDrag: true
)

SupportAI.configure(
    configuration: config,
    onCustomAction: { action in
        // Handle custom actions
    }
)
```

### Configuration Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `apiKey` | `String` | Required | Your API key |
| `apiEndpoint` | `String?` | Default endpoint | Custom API endpoint |
| `userId` | `String?` | `nil` | User ID for conversation tracking |
| `theme` | `SupportAITheme` | `.default` | Visual customization |
| `welcomeMessage` | `String` | "Hi! How can I help you today?" | First message shown |
| `inputPlaceholder` | `String` | "Message..." | Input field placeholder |
| `headerTitle` | `String` | "Support" | Chat header title |
| `headerSubtitle` | `String` | "Ask me anything" | Chat header subtitle |
| `allowButtonDrag` | `Bool` | `true` | Allow dragging floating button |

### Theme Customization

```swift
let theme = SupportAITheme(
    primaryColorHex: "#007AFF",
    userBubbleColorHex: "#007AFF",
    userTextColorHex: "#FFFFFF",
    assistantBubbleColorHex: "#E5E5EA",
    assistantTextColorHex: "#000000",
    floatingButtonColorHex: "#007AFF",
    floatingButtonSize: 60,
    supportIcon: "headphones"  // SF Symbol name
)
```

Or use presets:

```swift
.default                           // Default blue theme
.custom(primaryColor: "#FF5722")   // Custom primary color
```

## Programmatic Control

```swift
// Show/hide the floating button
SupportAI.show()
SupportAI.hide()

// Expand/minimize chat
SupportAI.expand()
SupportAI.minimize()

// Start a new conversation
SupportAI.startNewChat()
```

## Action Buttons

The SDK supports two types of actions:

### Built-in Actions (Handled Automatically)

These are handled by the SDK — no code needed:

| Action ID | Description | Data |
|-----------|-------------|------|
| `open_url` | Opens URL in browser | `{ "url": "https://..." }` |
| `copy_text` | Copies to clipboard | `{ "text": "..." }` |
| `call` | Opens phone dialer | `{ "phone": "+1234567890" }` |
| `email` | Opens email composer | `{ "email": "...", "subject": "..." }` |
| `share` | Opens share sheet | `{ "text": "..." }` |
| `dismiss` | Minimizes chat | — |

### Custom Actions (Handled by Your App)

Any action ID not in the built-in list is passed to your `onCustomAction` handler:

```swift
SupportAI.configure(
    apiKey: "sk_live_...",
    onCustomAction: { action in
        // action.id - The action identifier
        // action.label - Display label
        // action.icon - SF Symbol name (optional)
        // action.data - Additional data (optional)
        
        switch action.id {
        case "open_esims":
            navigator.goToEsims()
        case "create_ticket":
            showTicketForm()
        case "view_order":
            if let orderId = action.data?["orderId"] {
                showOrder(orderId)
            }
        default:
            print("Unknown action: \(action.id)")
        }
    }
)
```

## Backend Integration

### Request Format

The SDK sends requests to your backend:

```http
POST /v1/chat
Content-Type: application/json
X-API-Key: sk_live_abc123...
X-User-ID: user_123

{
    "messages": [
        { "role": "user", "content": "How do I change app language?" },
        { "role": "assistant", "content": "To open..." },
        { "role": "user", "content": "What about iPhone?" }
    ],
    "conversationId": "conv_abc123"
}
```

### Response Format

Your backend should return:

```json
{
    "answer": "To open app settings, go to Settings > General > App or tab button below...",
    "conversationId": "conv_abc123",
    "actions": [
        {
            "type": "open_url",
            "label": "View Guide",
            "icon": "book",
            "data": { "url": "https://example.com/guide" }
        },
        {
            "type": "open_setting",
            "label": "View My app setting",
            "icon": "gearwheel"
        }
    ]
}
```

### Action Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | `String` | ✅ | Action identifier |
| `label` | `String` | ✅ | Button label |
| `icon` | `String` | ❌ | SF Symbol name |
| `data` | `Object` | ❌ | Additional data |


## Error Handling

The SDK handles errors gracefully:

| Error | Message |
|-------|---------|
| Invalid API Key | "Invalid API key. Check your configuration." |
| Rate Limited | "Too many requests. Please try again later." |
| Network Error | "Sorry, something went wrong. Please try again." |

## Architecture

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│   iOS App       │         │   Your Backend  │         │        A        │
│   (SDK)         │         │   (REST API)    │         │                 │
└────────┬────────┘         └────────┬────────┘         └────────┬────────┘
         │                           │                           │
         │  POST /chat               │                           │
         │  X-API-Key: sk_live_...   │                           │
         │ ─────────────────────────>│                           │
         │                           │  Generate response        │
         │                           │ ─────────────────────────>│
         │                           │                           │
         │                           │  Response + actions       │
         │                           │ <─────────────────────────│
         │  { answer, actions }      │                           │
         │ <─────────────────────────│                           │
         │                           │                           │
         │  Display response         │                           │
         │  Show action buttons      │                           │
         │                           │                           │
         │  User taps built-in       │                           │
         │  → SDK handles it         │                           │
         │                           │                           │
         │  User taps custom         │                           │
         │  → App handles it         │                           │
```

## Requirements

- iOS 15.0+
- Swift 5.7+
- Xcode 14+

## License

MIT License. See [LICENSE](LICENSE) for details.
