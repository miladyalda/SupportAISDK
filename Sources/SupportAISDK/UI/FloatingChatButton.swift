//
//  FloatingChatButton.swift
//  SupportAISDK
//
//  Created by milad yalda on 2026-02-15.
//

import SwiftUI

struct FloatingChatButton: View {
    
    @ObservedObject var manager: SupportAIManager
    let theme: SupportAITheme
    let namespace: Namespace.ID
    
    var body: some View {
        Button {
            manager.expand()
        } label: {
            ZStack {
                Circle()
                    .fill(theme.floatingButtonColor)
                    .frame(width: theme.floatingButtonSize, height: theme.floatingButtonSize)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .matchedGeometryEffect(id: "chatBackground", in: namespace)
                
                if let iconName = theme.supportIcon {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(theme.floatingButtonIconColor)
                        .matchedGeometryEffect(id: "chatIcon", in: namespace)
                } else {
                    Image(systemName: "message.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(theme.floatingButtonIconColor)
                        .matchedGeometryEffect(id: "chatIcon", in: namespace)
                }
                
                // Unread badge
                if manager.hasUnreadMessages {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 18, height: 18)
                        .overlay(
                            Text("!")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .offset(x: theme.floatingButtonSize / 2 - 8, y: -theme.floatingButtonSize / 2 + 8)
                        .transition(.scale)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
