//
//  ChatResponse.swift
//  SupportAISDK
//
//  Created by milad yalda on 2026-02-15.
//

import Foundation

public struct ChatResponse: Sendable {
    public let answer: String
    public let conversationId: String
    public let actions: [ChatAction]
    
    public init(answer: String, conversationId: String, actions: [ChatAction] = []) {
        self.answer = answer
        self.conversationId = conversationId
        self.actions = actions
    }
}
