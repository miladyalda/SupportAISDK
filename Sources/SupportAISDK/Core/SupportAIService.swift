//
//  SupportAIService.swift
//  SupportAISDK
//

import Foundation

public final class SupportAIService: Sendable {
    
    private let configuration: SupportAIConfiguration
    
    public init(configuration: SupportAIConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Configure Actions
    
    /// Send custom actions to the backend
    public func configureActions() async throws {
        // Skip if no custom actions
        guard !configuration.actions.isEmpty else {
            print("ℹ️ [SupportAI] No custom actions to configure")
            return
        }
        
        guard let url = URL(string: configuration.endpoints.configureActions) else {
            throw SupportAIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(configuration.apiKey, forHTTPHeaderField: "X-API-Key")
        
        let body: [String: Any] = [
            "actions": configuration.actions.map { $0.dictionary }
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        print("🔧 [SupportAI] Configuring \(configuration.actions.count) action(s)...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SupportAIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ [SupportAI] Actions configured: \(responseString)")
            }
        case 401:
            throw SupportAIError.invalidAPIKey
        case 403:
            throw SupportAIError.forbidden
        default:
            throw SupportAIError.httpError(statusCode: httpResponse.statusCode)
        }
    }
    
    // MARK: - Send Message
    
    /// Send messages to the API and get response
    public func sendMessage(
        messages: [ChatMessage],
        conversationId: String?
    ) async throws -> ChatResponse {
        
        guard let url = URL(string: configuration.endpoints.chat) else {
            throw SupportAIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(configuration.apiKey, forHTTPHeaderField: "X-API-Key")
        
        if let userId = configuration.userId {
            request.setValue(userId, forHTTPHeaderField: "X-User-ID")
        }
        
        // Build body
        var body: [String: Any] = [
            "messages": messages.map { ["role": $0.role.rawValue, "content": $0.content] }
        ]
        
        if let conversationId = conversationId {
            body["conversationId"] = conversationId
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        // DEBUG: Print full request
        print("🚀 [SupportAI] ===== REQUEST =====")
        print("🚀 URL: \(url.absoluteString)")
        print("🚀 Method: POST")
        print("🚀 Headers:")
        request.allHTTPHeaderFields?.forEach { print("   \($0.key): \($0.value)") }
        if let bodyString = String(data: jsonData, encoding: .utf8) {
            print("🚀 Body: \(bodyString)")
        }
        print("🚀 ===== END REQUEST =====")
        
        // Make request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SupportAIError.invalidResponse
        }
        
        // DEBUG: Print full response
        print("📥 [SupportAI] ===== RESPONSE =====")
        print("📥 Status: \(httpResponse.statusCode)")
        print("📥 Headers:")
        httpResponse.allHeaderFields.forEach { print("   \($0.key): \($0.value)") }
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 Body: \(responseString)")
        }
        print("📥 ===== END RESPONSE =====")
        
        // Handle errors
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw SupportAIError.invalidAPIKey
        case 403:
            throw SupportAIError.forbidden
        case 429:
            throw SupportAIError.rateLimited
        default:
            throw SupportAIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        return try parseResponse(data: data)
    }
    
    // MARK: - Parse Response
    
    private func parseResponse(data: Data) throws -> ChatResponse {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw SupportAIError.parsingError
        }
        
        guard let answer = json["answer"] as? String,
              let conversationId = json["conversationId"] as? String else {
            throw SupportAIError.parsingError
        }
        
        // Parse actions
        var actions: [ChatAction] = []
        if let actionsData = json["actions"] as? [[String: Any]] {
            actions = actionsData.compactMap { actionDict in
                guard let id = actionDict["type"] as? String ?? actionDict["id"] as? String,
                      let label = actionDict["label"] as? String else {
                    return nil
                }
                let icon = actionDict["icon"] as? String
                let data = actionDict["data"] as? [String: String]
                return ChatAction(id: id, label: label, icon: icon, data: data)
            }
        }
        
        return ChatResponse(
            answer: answer,
            conversationId: conversationId,
            actions: actions
        )
    }
}

// MARK: - Errors

public enum SupportAIError: LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case invalidAPIKey
    case forbidden
    case rateLimited
    case httpError(statusCode: Int)
    case parsingError
    case notConfigured
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API endpoint URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidAPIKey:
            return "Invalid API key. Check your configuration."
        case .forbidden:
            return "Access forbidden. Check your API key permissions."
        case .rateLimited:
            return "Too many requests. Please try again later."
        case .httpError(let statusCode):
            return "Server error: \(statusCode)"
        case .parsingError:
            return "Failed to parse server response"
        case .notConfigured:
            return "SupportAISDK not configured. Call SupportAI.configure() first."
        }
    }
}
