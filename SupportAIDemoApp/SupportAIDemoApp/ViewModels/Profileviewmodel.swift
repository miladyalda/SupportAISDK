//
//  Profileviewmodel.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import Foundation
import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoading: Bool = false
    @Published var showSaveConfirmation: Bool = false
    
    private let dataService = MockDataService.shared
    
    init() {
        self.user = dataService.getCurrentUser()
    }
    
    func loadUser() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            self.user = self.dataService.getCurrentUser()
            self.isLoading = false
        }
    }
    
    // MARK: - Update Methods
    
    func updateName(_ name: String) {
        user.name = name
        saveChanges()
    }
    
    func updateEmail(_ email: String) {
        user.email = email
        saveChanges()
    }
    
    func updatePhone(_ phone: String) {
        user.phone = phone
        saveChanges()
    }
    
    func updateAddress(_ address: Address) {
        user.address = address
        saveChanges()
    }
    
    func updatePaymentMethod(_ paymentMethod: PaymentMethod?) {
        user.paymentMethod = paymentMethod
        saveChanges()
    }
    
    // MARK: - Preferences
    
    func toggleNotifications() {
        user.preferences.notificationsEnabled.toggle()
        saveChanges()
    }
    
    func toggleEmailUpdates() {
        user.preferences.emailUpdates.toggle()
        saveChanges()
    }
    
    func toggleDarkMode() {
        user.preferences.darkMode.toggle()
        saveChanges()
    }
    
    var notificationsEnabled: Bool {
        user.preferences.notificationsEnabled
    }
    
    var emailUpdatesEnabled: Bool {
        user.preferences.emailUpdates
    }
    
    var darkModeEnabled: Bool {
        user.preferences.darkMode
    }
    
    // MARK: - Save
    
    private func saveChanges() {
        // In a real app, this would save to backend
        showSaveConfirmation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.showSaveConfirmation = false
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        // In a real app, clear tokens, reset state, etc.
        print("User logged out")
    }
}
