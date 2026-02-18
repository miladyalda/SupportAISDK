//
//  SupportAIConfiguration.swift
//  SupportAISDK
//

import Foundation

public struct SupportAIConfiguration: Sendable {
    
    public let apiKey: String
    public let endpoints: SupportAIEndpoints
    public let userId: String?
    public let actions: [SupportAIAction]
    public let theme: SupportAITheme
    public let welcomeMessage: String
    public let inputPlaceholder: String
    public let headerTitle: String
    public let headerSubtitle: String
    public let allowButtonDrag: Bool
    public let hiddenOnScreens: [String]
    
    public init(
        apiKey: String,
        endpoints: SupportAIEndpoints = .production,
        userId: String? = nil,
        actions: [SupportAIAction] = [],
        theme: SupportAITheme = .default,
        welcomeMessage: String = "Hi! How can I help you today?",
        inputPlaceholder: String = "Message...",
        headerTitle: String = "Support",
        headerSubtitle: String = "Ask me anything",
        allowButtonDrag: Bool = true,
        hiddenOnScreens: [String] = []
    ) {
        self.apiKey = apiKey
        self.endpoints = endpoints
        self.userId = userId
        self.actions = actions
        self.theme = theme
        self.welcomeMessage = welcomeMessage
        self.inputPlaceholder = inputPlaceholder
        self.headerTitle = headerTitle
        self.headerSubtitle = headerSubtitle
        self.allowButtonDrag = allowButtonDrag
        self.hiddenOnScreens = hiddenOnScreens
    }
}
