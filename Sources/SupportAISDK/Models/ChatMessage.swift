//
//  ChatMessage.swift
//  SupportAISDK
//
//  Created by milad yalda on 2026-02-15.
//

import Foundation

public enum MessageRole: String, Codable, Sendable {
    case user = "user"
    case assistant = "assistant"
}

public struct ChatMessage: Identifiable, Equatable, Sendable {
    public let id: String
    public let content: String
    public let role: MessageRole
    public let timestamp: Date
    public let actions: [ChatAction]
    public let isLocalOnly: Bool  // Don't send to API
    
    public init(
        id: String = UUID().uuidString,
        content: String,
        role: MessageRole,
        timestamp: Date = Date(),
        actions: [ChatAction] = [],
        isLocalOnly: Bool = false
    ) {
        self.id = id
        self.content = content
        self.role = role
        self.timestamp = timestamp
        self.actions = actions
        self.isLocalOnly = isLocalOnly
    }
    
    public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
    
    public var dictionary: [String: Any] {
        return [
            "role": role.rawValue,
            "content": content
        ]
    }
}
