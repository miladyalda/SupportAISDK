//
//  SupportAISDK.swift
//  SupportAISDK
//

import SwiftUI

// MARK: - Public API

public struct SupportAI {
    
    /// Simple configuration with just API key
    public static func configure(
        apiKey: String,
        userId: String? = nil,
        theme: SupportAITheme = .default,
        welcomeMessage: String = "Hi! How can I help you today?",
        headerTitle: String = "Support",
        headerSubtitle: String = "Ask me anything",
        onCustomAction: (@MainActor (ChatAction) -> Void)? = nil
    ) {
        let configuration = SupportAIConfiguration(
            apiKey: apiKey,
            userId: userId,
            theme: theme,
            welcomeMessage: welcomeMessage,
            headerTitle: headerTitle,
            headerSubtitle: headerSubtitle
        )
        
        Task { @MainActor in
            SupportAIManager.shared.configure(
                configuration: configuration,
                onCustomAction: onCustomAction
            )
        }
    }
    
    /// Full configuration
    public static func configure(
        configuration: SupportAIConfiguration,
        onCustomAction: (@MainActor (ChatAction) -> Void)? = nil
    ) {
        Task { @MainActor in
            SupportAIManager.shared.configure(
                configuration: configuration,
                onCustomAction: onCustomAction
            )
        }
    }
    
    public static func show() {
        Task { @MainActor in
            SupportAIManager.shared.show()
        }
    }
    
    public static func hide() {
        Task { @MainActor in
            SupportAIManager.shared.hide()
        }
    }
    
    public static func expand() {
        Task { @MainActor in
            SupportAIManager.shared.expand()
        }
    }
    
    public static func minimize() {
        Task { @MainActor in
            SupportAIManager.shared.minimize()
        }
    }
    
    public static func startNewChat() {
        Task { @MainActor in
            SupportAIManager.shared.startNewChat()
        }
    }
}

// MARK: - View Modifier

public struct SupportAIChatModifier: ViewModifier {
    
    let configuration: SupportAIConfiguration
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            ChatOverlayView(configuration: configuration)
        }
    }
}

// MARK: - View Extension

public extension View {
    
    /// Simple - just API key
    func withSupportAIChat(apiKey: String) -> some View {
        let configuration = SupportAIConfiguration(apiKey: apiKey)
        return self.modifier(SupportAIChatModifier(configuration: configuration))
    }
    
    /// Full configuration
    func withSupportAIChat(configuration: SupportAIConfiguration) -> some View {
        self.modifier(SupportAIChatModifier(configuration: configuration))
    }
}
