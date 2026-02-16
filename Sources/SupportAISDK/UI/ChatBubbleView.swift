//
//  ChatBubbleView.swift
//  SupportAISDK
//
//  Created by milad yalda on 2026-02-15.
//

import SwiftUI

struct ChatBubbleView: View {
    
    let message: ChatMessage
    let theme: SupportAITheme
    var onAction: ((ChatAction) -> Void)?
    
    var body: some View {
        VStack(alignment: message.role == .assistant ? .leading : .trailing, spacing: 6) {
            // Assistant icon
            if message.role == .assistant {
                HStack(spacing: 8) {
                    if let iconName = theme.supportIcon {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(theme.primaryColor)
                    } else {
                        Image(systemName: "message.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(theme.primaryColor)
                    }
                    
                    Text("Support")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Bubble
            Text(message.content)
                .padding(12)
                .background(message.role == .user ? theme.userBubbleColor : theme.assistantBubbleColor)
                .foregroundColor(message.role == .user ? theme.userTextColor : theme.assistantTextColor)
                .cornerRadius(theme.bubbleCornerRadius)
            
            // Action buttons
            if message.role == .assistant && !message.actions.isEmpty {
                HStack(spacing: 8) {
                    ForEach(message.actions) { action in
                        Button {
                            onAction?(action)
                        } label: {
                            HStack(spacing: 6) {
                                if let icon = action.icon {
                                    Image(systemName: icon)
                                        .font(.subheadline)
                                }
                                Text(action.label)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
        .padding(.horizontal)
    }
}
