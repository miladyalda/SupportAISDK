//
//  SupportAIManager.swift
//  SupportAISDK
//

import SwiftUI

@MainActor
public final class SupportAIManager: ObservableObject {
    
    // MARK: - Singleton
    
    public static let shared = SupportAIManager()
    
    // MARK: - Published State
    
    @Published public var state: ChatState = .minimized
    @Published public var messages: [ChatMessage] = []
    @Published public var isLoading: Bool = false
    @Published public var hasUnreadMessages: Bool = false
    @Published public private(set) var conversationId: String?
    
    // MARK: - Share Sheet State
    
    @Published public var shareText: String?
    @Published public var showShareSheet: Bool = false
    
    // MARK: - Configuration
    
    public private(set) var configuration: SupportAIConfiguration = SupportAIConfiguration(apiKey: "")
    private var service: SupportAIService?
    private var onCustomActionHandler: (@MainActor (ChatAction) -> Void)?
    
    // MARK: - Persistence
    
    @AppStorage("supportai_conversation_id") private var savedConversationId: String?
    
    // MARK: - State Enum
    
    public enum ChatState: Sendable {
        case hidden
        case minimized
        case expanded
    }
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Configuration
    
    public func configure(
        configuration: SupportAIConfiguration,
        onCustomAction: (@MainActor (ChatAction) -> Void)? = nil
    ) {
        self.configuration = configuration  // No longer optional
        self.service = SupportAIService(configuration: configuration)
        self.onCustomActionHandler = onCustomAction
        
        // Restore conversation or show welcome
        if let savedId = savedConversationId {
            self.conversationId = savedId
        }
        
        // Add welcome message if no messages
        if messages.isEmpty {
            messages.append(ChatMessage(
                content: configuration.welcomeMessage,
                role: .assistant
            ))
        }
    }
    
    // MARK: - State Actions
    
    public func expand() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            state = .expanded
            hasUnreadMessages = false
        }
    }
    
    public func minimize() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            state = .minimized
        }
    }
    
    public func hide() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
            state = .hidden
        }
    }
    
    public func show() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
            state = .minimized
        }
    }
    
    public func toggle() {
        if state == .expanded {
            minimize()
        } else {
            expand()
        }
    }
    
    // MARK: - Messaging
    
    public func sendMessage(_ text: String) async {
        guard let currentService = service else {
            print("⚠️ SupportAISDK: Not configured. Call SupportAI.configure() first.")
            return
        }

        let config = configuration  // No longer optional
        
        print("✅ [SupportAI] Endpoint: \(config.apiEndpoint)")
        print("✅ [SupportAI] API Key: \(config.apiKey.prefix(15))...")
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        // Add user message
        let userMessage = ChatMessage(content: trimmedText, role: .user)
        messages.append(userMessage)
        
        isLoading = true
        
        // FILTER: Only send valid messages (exclude welcome and errors)
        let messagesToSend = messages.filter { message in
            // Exclude error messages
            if message.role == .assistant && message.content.contains("error") {
                return false
            }
            // Exclude welcome message (first assistant message with no conversationId)
            if message.role == .assistant && conversationId == nil && message == messages.first {
                return false
            }
            return true
        }
        
        // Actually, simpler approach: only send user messages for new conversations
        // or the last few messages for existing ones
        let finalMessages: [ChatMessage]
        if conversationId == nil {
            // New conversation: only send the current user message
            finalMessages = [userMessage]
        } else {
            // Existing conversation: send last 10 messages, excluding errors
            finalMessages = messages
                .filter { !$0.content.lowercased().contains("error") }
                .suffix(10)
                .map { $0 }
        }
        
        let currentConversationId = conversationId
        
        do {
            let response = try await currentService.sendMessage(
                messages: finalMessages,
                conversationId: currentConversationId
            )
            
            // Update conversation ID
            if conversationId == nil {
                conversationId = response.conversationId
                savedConversationId = response.conversationId
            }
            
            // Add assistant message
            let assistantMessage = ChatMessage(
                content: response.answer,
                role: .assistant,
                actions: response.actions
            )
            messages.append(assistantMessage)
            
            // Notify if minimized
            if state == .minimized {
                hasUnreadMessages = true
            }
            
        } catch let error as SupportAIError {
            // Add error message locally but mark it so we don't send it
            let errorMessage = ChatMessage(
                content: "Sorry, something went wrong. Please try again.",
                role: .assistant
            )
            messages.append(errorMessage)
            print("⚠️ SupportAISDK Error: \(error.localizedDescription)")
        } catch {
            let errorMessage = ChatMessage(
                content: "Sorry, something went wrong. Please try again.",
                role: .assistant
            )
            messages.append(errorMessage)
            print("⚠️ SupportAISDK Error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Action Handling
    
    public func handleAction(_ action: ChatAction) {
        if let builtInType = action.builtInType {
            handleBuiltInAction(builtInType, action: action)
        } else {
            onCustomActionHandler?(action)
        }
    }
    
    private func handleBuiltInAction(_ type: BuiltInActionType, action: ChatAction) {
        switch type {
        case .openURL:
            if let urlString = action.data?["url"],
               let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
            
        case .copyText:
            if let text = action.data?["text"] {
                UIPasteboard.general.string = text
            }
            
        case .call:
            if let phone = action.data?["phone"],
               let url = URL(string: "tel://\(phone)") {
                UIApplication.shared.open(url)
            }
            
        case .email:
            if let email = action.data?["email"] {
                var urlString = "mailto:\(email)"
                if let subject = action.data?["subject"]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    urlString += "?subject=\(subject)"
                }
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
            
        case .share:
            if let text = action.data?["text"] {
                shareText = text
                showShareSheet = true
            }
            
        case .dismiss:
            minimize()
        }
    }
    
    // MARK: - New Chat
    
    public func startNewChat() {
        savedConversationId = nil
        conversationId = nil
        messages = [ChatMessage(
            content: configuration.welcomeMessage,
            role: .assistant
        )]
    }
}
