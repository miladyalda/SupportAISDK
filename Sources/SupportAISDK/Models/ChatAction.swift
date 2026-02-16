//
//  ChatAction.swift
//  SupportAISDK
//

import Foundation

// MARK: - Built-in Action Types

public enum BuiltInActionType: String, Sendable {
    case openURL = "open_url"
    case copyText = "copy_text"
    case call = "call"
    case email = "email"
    case share = "share"
    case dismiss = "dismiss"
}

// MARK: - Chat Action

public struct ChatAction: Identifiable, Equatable, Sendable {
    public let id: String
    public let label: String
    public let icon: String?
    public let data: [String: String]?
    
    /// Check if this is a built-in action
    public var builtInType: BuiltInActionType? {
        BuiltInActionType(rawValue: id)
    }
    
    /// Check if this is a custom action (handled by app)
    public var isCustom: Bool {
        builtInType == nil
    }
    
    public init(
        id: String,
        label: String,
        icon: String? = nil,
        data: [String: String]? = nil
    ) {
        self.id = id
        self.label = label
        self.icon = icon
        self.data = data
    }
    
    public static func == (lhs: ChatAction, rhs: ChatAction) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Built-in Action Constructors
    
    public static func openURL(_ url: String, label: String = "Open Link") -> ChatAction {
        ChatAction(id: BuiltInActionType.openURL.rawValue, label: label, icon: "safari", data: ["url": url])
    }
    
    public static func copyText(_ text: String, label: String = "Copy") -> ChatAction {
        ChatAction(id: BuiltInActionType.copyText.rawValue, label: label, icon: "doc.on.doc", data: ["text": text])
    }
    
    public static func call(_ phoneNumber: String, label: String = "Call") -> ChatAction {
        ChatAction(id: BuiltInActionType.call.rawValue, label: label, icon: "phone", data: ["phone": phoneNumber])
    }
    
    public static func email(_ address: String, subject: String? = nil, label: String = "Email") -> ChatAction {
        var data = ["email": address]
        if let subject = subject {
            data["subject"] = subject
        }
        return ChatAction(id: BuiltInActionType.email.rawValue, label: label, icon: "envelope", data: data)
    }
    
    public static func share(_ text: String, label: String = "Share") -> ChatAction {
        ChatAction(id: BuiltInActionType.share.rawValue, label: label, icon: "square.and.arrow.up", data: ["text": text])
    }
    
    public static func dismiss(label: String = "Close") -> ChatAction {
        ChatAction(id: BuiltInActionType.dismiss.rawValue, label: label, icon: "xmark", data: nil)
    }
    
    public static func custom(id: String, label: String, icon: String? = nil, data: [String: String]? = nil) -> ChatAction {
        ChatAction(id: id, label: label, icon: icon, data: data)
    }
}
