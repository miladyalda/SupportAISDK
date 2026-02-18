//
//  SupportAIAction.swift
//  SupportAISDK
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation

/// Action that can be triggered by the AI assistant
public struct SupportAIAction: Sendable {
    
    /// Unique identifier for the action (e.g., "open_settings", "show_pricing")
    public let id: String
    
    /// Display label shown on the button
    public let label: String
    
    /// Description for the AI to understand when to use this action
    public let description: String
    
    /// SF Symbol icon name (optional)
    public let icon: String?
    
    /// Additional data for the action (optional)
    public let data: [String: String]?
    
    public init(
        id: String,
        label: String,
        description: String,
        icon: String? = nil,
        data: [String: String]? = nil
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.icon = icon
        self.data = data
    }
    
    /// Convert to dictionary for API request
    var dictionary: [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "label": label,
            "description": description
        ]
        if let icon = icon {
            dict["icon"] = icon
        }
        if let data = data {
            dict["data"] = data
        }
        return dict
    }
}
