//
//  ChatOverlayView.swift
//  SupportAISDK
//

import SwiftUI

// MARK: - Chat Size

public enum ChatSize: Sendable {
    case quarter
    case half
    case full
    
    var heightFraction: CGFloat {
        switch self {
        case .quarter: return 0.35
        case .half: return 0.55
        case .full: return 0.92
        }
    }
    
    var next: ChatSize {
        switch self {
        case .quarter: return .half
        case .half: return .full
        case .full: return .quarter
        }
    }
    
    var icon: String {
        switch self {
        case .quarter: return "arrow.up.left.and.arrow.down.right"
        case .half: return "arrow.up.left.and.arrow.down.right"
        case .full: return "arrow.down.right.and.arrow.up.left"
        }
    }
}

// MARK: - Chat Overlay View

public struct ChatOverlayView: View {
    
    @ObservedObject private var manager = SupportAIManager.shared
    
    private var configuration: SupportAIConfiguration {
        manager.configuration
    }
    
    @Namespace private var chatNamespace
    @State private var inputText = ""
    @FocusState private var isInputFocused: Bool
    
    // Size management
    @State private var chatSize: ChatSize = .quarter
    @State private var dragOffset: CGFloat = 0
    
    // Floating button position
    @State private var buttonPosition: CGPoint = CGPoint(
        x: UIScreen.main.bounds.width - 50,
        y: UIScreen.main.bounds.height - 150
    )
    @GestureState private var buttonDragOffset: CGSize = .zero
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                if manager.state == .expanded {
                    // Dimmed background
                    Color.black.opacity(chatSize == .full ? 0.3 : 0.15)
                        .ignoresSafeArea()
                        .onTapGesture {
                            manager.minimize()
                        }
                    
                    // Chat overlay
                    expandedChat(geometry: geometry)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                } else if manager.state == .minimized {
                    floatingButton
                        .position(
                            x: buttonPosition.x + buttonDragOffset.width,
                            y: buttonPosition.y + buttonDragOffset.height
                        )
                        .gesture(configuration.allowButtonDrag ? buttonDragGesture(geometry: geometry) : nil)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $manager.showShareSheet) {
            if let text = manager.shareText {
                ShareSheet(items: [text])
            }
        }
    }
    
    // MARK: - Expanded Chat
    
    private func expandedChat(geometry: GeometryProxy) -> some View {
        let height = geometry.size.height * chatSize.heightFraction + dragOffset
        let minHeight = geometry.size.height * 0.25
        let maxHeight = geometry.size.height * 0.92
        let clampedHeight = min(max(height, minHeight), maxHeight)
        
        return VStack(spacing: 0) {
            // Drag handle
            dragHandle
            
            // Header
            chatHeader
            
            // Content
            chatContent
            
            // Input
            ChatInputBar(
                manager: manager,
                theme: configuration.theme,
                placeholder: configuration.inputPlaceholder,
                text: $inputText,
                isFocused: $isInputFocused
            )
        }
        .frame(width: geometry.size.width, height: clampedHeight)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: -5)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .gesture(resizeDragGesture(geometry: geometry))
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: chatSize)
    }
    
    // MARK: - Drag Handle
    
    private var dragHandle: some View {
        VStack(spacing: 8) {
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
    
    // MARK: - Header
    
    private var chatHeader: some View {
        HStack(spacing: 12) {
            // Icon
            if let iconName = configuration.theme.supportIcon {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(configuration.theme.primaryColor)
            } else {
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(configuration.theme.primaryColor)
            }
            
            // Title
            VStack(alignment: .leading, spacing: 1) {
                Text(configuration.headerTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(configuration.headerSubtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Size toggle button
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    chatSize = chatSize.next
                }
            } label: {
                Image(systemName: chatSize.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Circle())
            }
            
            // New chat button
            Button {
                manager.startNewChat()
            } label: {
                Image(systemName: "plus.message")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Circle())
            }
            
            // Minimize button
            Button {
                manager.minimize()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(configuration.theme.headerBackgroundColor)
    }
    
    // MARK: - Chat Content
    
    private var chatContent: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(manager.messages) { message in
                        ChatBubbleView(
                            message: message,
                            theme: configuration.theme,
                            onAction: { action in
                                manager.handleAction(action)
                            }
                        )
                    }
                    
                    if manager.isLoading {
                        loadingView
                    }
                    
                    Color.clear
                        .frame(height: 1)
                        .id("BOTTOM")
                }
                .padding(.top, 8)
            }
            .onChange(of: manager.messages.count) { _ in
                withAnimation {
                    proxy.scrollTo("BOTTOM", anchor: .bottom)
                }
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        HStack(spacing: 8) {
            Image(systemName: configuration.theme.supportIcon ?? "message.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.theme.primaryColor)
            
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .scaleEffect(manager.isLoading ? 1 : 0.5)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: manager.isLoading
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(configuration.theme.assistantBubbleColor)
            .cornerRadius(configuration.theme.bubbleCornerRadius)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    // MARK: - Floating Button
    
    private var floatingButton: some View {
        FloatingChatButton(
            manager: manager,
            theme: configuration.theme,
            namespace: chatNamespace
        )
    }
    
    // MARK: - Resize Drag Gesture
    
    private func resizeDragGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = -value.translation.height
            }
            .onEnded { value in
                let velocity = -value.predictedEndTranslation.height
                let threshold = geometry.size.height * 0.1
                
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    if velocity > threshold {
                        switch chatSize {
                        case .quarter: chatSize = .half
                        case .half: chatSize = .full
                        case .full: break
                        }
                    } else if velocity < -threshold {
                        switch chatSize {
                        case .quarter: manager.minimize()
                        case .half: chatSize = .quarter
                        case .full: chatSize = .half
                        }
                    }
                    dragOffset = 0
                }
            }
    }
    
    // MARK: - Button Drag Gesture
    
    private func buttonDragGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($buttonDragOffset) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                var newX = buttonPosition.x + value.translation.width
                var newY = buttonPosition.y + value.translation.height
                
                let padding: CGFloat = 40
                newX = max(padding, min(geometry.size.width - padding, newX))
                newY = max(padding + geometry.safeAreaInsets.top, min(geometry.size.height - padding - geometry.safeAreaInsets.bottom, newY))
                
                if newX < geometry.size.width / 2 {
                    newX = padding
                } else {
                    newX = geometry.size.width - padding
                }
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    buttonPosition = CGPoint(x: newX, y: newY)
                }
            }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
