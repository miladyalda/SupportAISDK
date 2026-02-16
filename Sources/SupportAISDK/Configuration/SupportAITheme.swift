//
//  SupportAITheme.swift
//  SupportAISDK
//

import SwiftUI

public struct SupportAITheme: Sendable {
    
    // MARK: - Color Storage (as hex strings for Sendable)
    
    private let primaryColorHex: String
    private let userBubbleColorHex: String
    private let userTextColorHex: String
    private let assistantBubbleColorHex: String
    private let assistantTextColorHex: String
    private let floatingButtonColorHex: String
    private let floatingButtonIconColorHex: String
    private let headerBackgroundColorHex: String
    private let inputBackgroundColorHex: String
    
    // MARK: - Computed Colors
    
    public var primaryColor: Color { Color(hex: primaryColorHex) }
    public var userBubbleColor: Color { Color(hex: userBubbleColorHex) }
    public var userTextColor: Color { Color(hex: userTextColorHex) }
    public var assistantBubbleColor: Color { Color(hex: assistantBubbleColorHex) }
    public var assistantTextColor: Color { Color(hex: assistantTextColorHex) }
    public var floatingButtonColor: Color { Color(hex: floatingButtonColorHex) }
    public var floatingButtonIconColor: Color { Color(hex: floatingButtonIconColorHex) }
    public var headerBackgroundColor: Color { Color(hex: headerBackgroundColorHex) }
    public var inputBackgroundColor: Color { Color(hex: inputBackgroundColorHex) }
    
    // MARK: - Dimensions
    
    public let floatingButtonSize: CGFloat
    public let bubbleCornerRadius: CGFloat
    public let overlayCornerRadius: CGFloat
    
    // MARK: - Images
    
    public let supportIcon: String?
    
    public init(
        primaryColor: String = "#007AFF",
        userBubbleColor: String = "#007AFF",
        userTextColor: String = "#FFFFFF",
        assistantBubbleColor: String = "#E5E5EA",
        assistantTextColor: String = "#000000",
        floatingButtonColor: String = "#007AFF",
        floatingButtonIconColor: String = "#FFFFFF",
        headerBackgroundColor: String = "#F2F2F7",
        inputBackgroundColor: String = "#F2F2F7",
        floatingButtonSize: CGFloat = 60,
        bubbleCornerRadius: CGFloat = 18,
        overlayCornerRadius: CGFloat = 20,
        supportIcon: String? = nil
    ) {
        self.primaryColorHex = primaryColor
        self.userBubbleColorHex = userBubbleColor
        self.userTextColorHex = userTextColor
        self.assistantBubbleColorHex = assistantBubbleColor
        self.assistantTextColorHex = assistantTextColor
        self.floatingButtonColorHex = floatingButtonColor
        self.floatingButtonIconColorHex = floatingButtonIconColor
        self.headerBackgroundColorHex = headerBackgroundColor
        self.inputBackgroundColorHex = inputBackgroundColor
        self.floatingButtonSize = floatingButtonSize
        self.bubbleCornerRadius = bubbleCornerRadius
        self.overlayCornerRadius = overlayCornerRadius
        self.supportIcon = supportIcon
    }
    
    // MARK: - Presets
    
    public static let `default` = SupportAITheme()
    
    public static func custom(primaryColor: String) -> SupportAITheme {
        SupportAITheme(
            primaryColor: primaryColor,
            userBubbleColor: primaryColor,
            floatingButtonColor: primaryColor
        )
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
