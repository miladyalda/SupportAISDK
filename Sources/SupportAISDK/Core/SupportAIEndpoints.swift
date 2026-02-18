//
//  SupportAIEndpoints.swift
//  SupportAISDK
//
//  Created by milad yalda on 2026-02-18.
//

public struct SupportAIEndpoints: Sendable {
    
    /// Chat endpoint URL
    public let chat: String
    
    /// Configure actions endpoint URL
    public let configureActions: String
    
    /// Default production endpoints
    public static let production = SupportAIEndpoints(
        chat: "https://chat-mijzg7h4kq-uc.a.run.app",
        configureActions: "https://configureactions-mijzg7h4kq-uc.a.run.app"
    )
    
    /// For custom/self-hosted backends with separate URLs
    public init(chat: String, configureActions: String) {
        self.chat = chat
        self.configureActions = configureActions
    }
    
    /// For custom/self-hosted backends with shared base URL
    public init(baseURL: String) {
        self.chat = "\(baseURL)/chat"
        self.configureActions = "\(baseURL)/configureActions"
    }
}
