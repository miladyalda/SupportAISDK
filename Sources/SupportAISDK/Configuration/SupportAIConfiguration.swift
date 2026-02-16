//
//  SupportAIConfiguration.swift
//  SupportAISDK
//

import Foundation

public struct SupportAIConfiguration: Sendable {
    
    public let apiKey: String
    public let apiEndpoint: String
    public let userId: String?
    public let theme: SupportAITheme
    public let welcomeMessage: String
    public let inputPlaceholder: String
    public let headerTitle: String
    public let headerSubtitle: String
    public let allowButtonDrag: Bool
    public let hiddenOnScreens: [String]
    
    /// Default API endpoint
    public static let defaultEndpoint = "https://asksupportrest-k4n3dfwncq-uc.a.run.app"
    
    public init(
        apiKey: String,
        apiEndpoint: String? = nil,
        userId: String? = nil,
        theme: SupportAITheme = .default,
        welcomeMessage: String = "Hi! How can I help you today?",
        inputPlaceholder: String = "Message...",
        headerTitle: String = "Support",
        headerSubtitle: String = "Ask me anything",
        allowButtonDrag: Bool = true,
        hiddenOnScreens: [String] = []
    ) {
        self.apiKey = apiKey
        self.apiEndpoint = apiEndpoint ?? Self.defaultEndpoint
        self.userId = userId
        self.theme = theme
        self.welcomeMessage = welcomeMessage
        self.inputPlaceholder = inputPlaceholder
        self.headerTitle = headerTitle
        self.headerSubtitle = headerSubtitle
        self.allowButtonDrag = allowButtonDrag
        self.hiddenOnScreens = hiddenOnScreens
    }
}
