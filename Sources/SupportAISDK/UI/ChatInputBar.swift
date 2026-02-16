//
//  ChatInputBar.swift
//  SupportAISDK
//
//  Created by milad yalda on 2026-02-15.
//

import SwiftUI

struct ChatInputBar: View {
    
    @ObservedObject var manager: SupportAIManager
    let theme: SupportAITheme
    let placeholder: String
    
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            TextField(placeholder, text: $text)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .lineLimit(5)
                .focused($isFocused)
            
            Button {
                let message = text
                text = ""
                Task {
                    await manager.sendMessage(message)
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(text.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : theme.primaryColor)
                    .rotationEffect(.degrees(45))
                    .font(.title2)
            }
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty || manager.isLoading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(theme.inputBackgroundColor)
    }
}
