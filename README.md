# SupportAI SDK

A plug-and-play AI-powered customer support chat SDK for iOS apps. Features a floating chat button with smooth morphing animations, API key authentication, dynamic action buttons, and full customization.

[![iOS 15+](https://img.shields.io/badge/iOS-15%2B-blue)](https://developer.apple.com/ios/)
[![Swift 5.7+](https://img.shields.io/badge/Swift-5.7%2B-orange)](https://swift.org/)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

<!-- Add a screenshot or GIF demo here -->
<!-- ![SupportAI Demo](assets/demo.gif) -->

## Features


| Feature | Description |
|---------|-------------|
| 🔑 **Simple API Key Auth** | Just add your API key, like Stripe |
| 🎯 **Floating Chat Button** | Draggable, always accessible |
| 💬 **Full Chat Interface** | Smooth morphing animation |
| 🎨 **Fully Customizable** | Colors, text, icons |
| 🤖 **AI-Powered Actions** | Define actions, AI decides when to show them |
| 🔘 **Built-in Actions** | URL, copy, call, email, share handled automatically |
| 🧩 **Custom Actions** | App-specific actions via callback |
| 📱 **iOS 15+** | Wide compatibility |

## Installation

### Swift Package Manager

Add to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/miladyalda/SupportAISDK.git", from: "1.0.0")
]
```

<details>
<summary><strong>Or add via Xcode</strong></summary>

1. Go to **File → Add Package Dependencies**
2. Enter the repository URL:
   ```
   https://github.com/miladyalda/SupportAISDK.git
   ```
3. Select version **1.0.0** or later
4. Click **Add Package**

</details>

> [!NOTE]
> Requires iOS 15.0+ and Swift 5.7+

## Quick Start

### 1. Get Your API Key

Get an API key from your backend dashboard. Keys look like:

```
sk_live_abc123...
```

### 2. Configure at App Launch

```swift
import SwiftUI
import SupportAISDK

@main
struct MyApp: App {
    
    init() {
        SupportAI.configure(
            apiKey: "sk_live_your_api_key_here",
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
            theme: .custom(primaryColor: "#007AFF"),
            headerTitle: "Support",
            headerSubtitle: "We're here to help",
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
                .withSupportAIChat()
        }
    }
}
```

### 3. That's it! 🎉

A floating chat button will appear on all screens. The AI will automatically show action buttons when relevant to the conversation.

> [!TIP]
> You can programmatically control the chat using `SupportAI.show()`, `SupportAI.hide()`, `SupportAI.expand()`, and `SupportAI.minimize()`.

## Configuration

### Simple Configuration

```swift
SupportAI.configure(
    apiKey: "sk_live_...",
    actions: [
        SupportAIAction(id: "help", label: "Get Help", description: "Shows help options")
    ],
    onCustomAction: { action in
        // Handle custom actions
    }
)
```

### Full Configuration

<details>
<summary><strong>View full configuration options</strong></summary>

```swift
let config = SupportAIConfiguration(
    apiKey: "sk_live_...",
    endpoints: .production,  // or custom endpoints
    userId: "user_123",
    actions: [
        SupportAIAction(
            id: "open_settings",
            label: "Open Settings",
            description: "Opens the app settings screen",
            icon: "gearshape"
        ),
        SupportAIAction(
            id: "create_ticket",
            label: "Create Ticket",
            description: "Creates a support ticket for complex issues",
            icon: "ticket"
        )
    ],
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

</details>

### Configuration Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `apiKey` | `String` | **Required** | Your API key |
| `endpoints` | `SupportAIEndpoints` | `.production` | API endpoints configuration |
| `userId` | `String?` | `nil` | User ID for conversation tracking |
| `actions` | `[SupportAIAction]` | `[]` | Custom actions the AI can trigger |
| `theme` | `SupportAITheme` | `.default` | Visual customization |
| `welcomeMessage` | `String` | `"Hi! How can I help you today?"` | First message shown |
| `inputPlaceholder` | `String` | `"Message..."` | Input field placeholder |
| `headerTitle` | `String` | `"Support"` | Chat header title |
| `headerSubtitle` | `String` | `"Ask me anything"` | Chat header subtitle |
| `allowButtonDrag` | `Bool` | `true` | Allow dragging floating button |

### Custom Endpoints

For self-hosted backends:

```swift
// Separate URLs
let endpoints = SupportAIEndpoints(
    chat: "https://your-api.com/chat",
    configureActions: "https://your-api.com/configureActions"
)

// Or shared base URL
let endpoints = SupportAIEndpoints(
    baseURL: "https://your-api.com"
)

SupportAI.configure(
    apiKey: "sk_live_...",
    endpoints: endpoints,
    // ...
)
```

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
// Default blue theme
.default

// Custom primary color
.custom(primaryColor: "#FF5722")
```

## Programmatic Control

```swift
SupportAI.show()         // Show the floating button
SupportAI.hide()         // Hide the floating button
SupportAI.expand()       // Open the chat interface
SupportAI.minimize()     // Minimize to floating button
SupportAI.startNewChat() // Start a new conversation
```

## Action Buttons

The SDK supports two types of actions:

### Defining Custom Actions

Custom actions are defined when configuring the SDK. The AI automatically decides when to show them based on the conversation:

```swift
SupportAI.configure(
    apiKey: "sk_live_...",
    actions: [
        SupportAIAction(
            id: "open_settings",           // Unique identifier
            label: "Open Settings",         // Button label
            description: "Opens the app settings screen",  // AI uses this to decide when to show
            icon: "gearshape"              // SF Symbol (optional)
        ),
        SupportAIAction(
            id: "show_order",
            label: "View Order",
            description: "Shows order details and tracking information",
            icon: "shippingbox"
        ),
        SupportAIAction(
            id: "contact_human",
            label: "Talk to Human",
            description: "Connects user to a human support agent",
            icon: "person"
        )
    ],
    onCustomAction: { action in
        switch action.id {
        case "open_settings":
            // Navigate to settings
            break
        case "show_order":
            // Show order screen
            break
        case "contact_human":
            // Connect to human agent
            break
        default:
            break
        }
    }
)
```

### SupportAIAction Properties

| Property | Type | Required | Description |
|----------|------|:--------:|-------------|
| `id` | `String` | ✅ | Unique identifier for the action |
| `label` | `String` | ✅ | Button label shown to user |
| `description` | `String` | ✅ | Description for AI to understand when to use |
| `icon` | `String?` | ❌ | SF Symbol name |
| `data` | `[String: String]?` | ❌ | Additional data |

### Built-in Actions

These are handled automatically by the SDK (no configuration needed):

| Action ID | Description | Data |
|-----------|-------------|------|
| `open_url` | Opens URL in browser | `{ "url": "https://..." }` |
| `copy_text` | Copies to clipboard | `{ "text": "..." }` |
| `call` | Opens phone dialer | `{ "phone": "+1234567890" }` |
| `email` | Opens email composer | `{ "email": "...", "subject": "..." }` |
| `share` | Opens share sheet | `{ "text": "..." }` |
| `dismiss` | Minimizes chat | — |

### Handling Custom Actions

Custom actions (any action not in the built-in list) are passed to your `onCustomAction` handler:

```swift
onCustomAction: { action in
    // action.id    → The action identifier
    // action.label → Display label
    // action.icon  → SF Symbol name (optional)
    // action.data  → Additional data (optional)
    
    switch action.id {
    case "open_settings":
        navigator.goToSettings()
    case "show_order":
        if let orderId = action.data?["orderId"] {
            showOrder(orderId)
        }
    default:
        print("Unknown action: \(action.id)")
    }
}
```

## Architecture

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│    iOS App      │         │  SupportAI API  │         │   Gemini AI     │
│     (SDK)       │         │   (Backend)     │         │                 │
└────────┬────────┘         └────────┬────────┘         └────────┬────────┘
         │                           │                           │
         │  Configure actions        │                           │
         │  POST /configureActions   │                           │
         │ ─────────────────────────>│                           │
         │                           │  Store actions            │
         │  ✓ Actions configured     │                           │
         │ <─────────────────────────│                           │
         │                           │                           │
         │  POST /chat               │                           │
         │  X-API-Key: sk_live_...   │                           │
         │ ─────────────────────────>│                           │
         │                           │  Generate response        │
         │                           │  (with function calling)  │
         │                           │ ─────────────────────────>│
         │                           │                           │
         │                           │  Response + actions       │
         │                           │ <─────────────────────────│
         │  { answer, actions }      │                           │
         │ <─────────────────────────│                           │
         │                           │                           │
         │  ✓ Display response       │                           │
         │  ✓ Show action buttons    │                           │
         │                           │                           │
         │  User taps built-in       │                           │
         │  → SDK handles it         │                           │
         │                           │                           │
         │  User taps custom         │                           │
         │  → App handles it         │                           │
```

## Backend Integration

### Endpoints

The SDK communicates with two endpoints:

#### 1. Configure Actions

Called automatically when SDK initializes with custom actions.

```http
POST /configureActions
Content-Type: application/json
X-API-Key: sk_live_abc123...
```

```json
{
    "actions": [
        {
            "id": "open_settings",
            "label": "Open Settings",
            "description": "Opens the app settings screen",
            "icon": "gearshape"
        }
    ]
}
```

**Response:**

```json
{
    "success": true,
    "actionCount": 1,
    "message": "Configured 1 custom action(s)"
}
```

#### 2. Chat

Called for each message sent.

```http
POST /chat
Content-Type: application/json
X-API-Key: sk_live_abc123...
X-User-ID: user_123
```

```json
{
    "messages": [
        { "role": "user", "content": "How do I change my settings?" }
    ],
    "conversationId": "conv_abc123"
}
```

**Response:**

```json
{
    "answer": "You can change your settings in the app settings screen. Would you like me to open it for you?",
    "conversationId": "conv_abc123",
    "actions": [
        {
            "type": "open_settings",
            "label": "Open Settings",
            "icon": "gearshape"
        }
    ]
}
```

### Action Response Schema

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `type` | `String` | ✅ | Action identifier |
| `label` | `String` | ✅ | Button label |
| `icon` | `String` | ❌ | SF Symbol name |
| `data` | `Object` | ❌ | Additional data |

## Error Handling

The SDK handles errors gracefully with user-friendly messages:

| Error | User Message |
|-------|--------------|
| Invalid API Key | "Invalid API key. Check your configuration." |
| Rate Limited | "Too many requests. Please try again later." |
| Network Error | "Sorry, something went wrong. Please try again." |

## Troubleshooting

<details>
<summary><strong>Chat button not appearing</strong></summary>

Make sure you've added the `.withSupportAIChat()` modifier to your root view:

```swift
ContentView()
    .withSupportAIChat()
```

And that you've called `SupportAI.configure()` before the view loads.

</details>

<details>
<summary><strong>Custom actions not firing</strong></summary>

Ensure you've configured the `onCustomAction` handler in `SupportAI.configure()`:

```swift
SupportAI.configure(
    apiKey: "sk_live_...",
    actions: [...],
    onCustomAction: { action in
        print("Action received: \(action.id)")
    }
)
```

</details>

<details>
<summary><strong>Actions not appearing in chat</strong></summary>

1. Make sure you've defined actions with clear descriptions
2. The AI decides when to show actions based on the conversation
3. Check console logs for "Actions configured" message
4. Try asking questions that relate to your action descriptions

</details>

<details>
<summary><strong>API key errors</strong></summary>

1. Verify your API key starts with `sk_live_` or `sk_test_`
2. Check that the key is correctly copied without extra spaces
3. Ensure your backend is validating the key correctly

</details>

## Requirements

| Requirement | Minimum Version |
|-------------|-----------------|
| iOS | 15.0+ |
| Swift | 5.7+ |
| Xcode | 14+ |

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting a PR.

## License

SupportAI SDK is available under the MIT License. See the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ for iOS developers
</p>
