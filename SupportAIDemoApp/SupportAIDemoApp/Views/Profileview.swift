//
//  Profileview.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var actionRouter: ActionRouter
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Header
                Section {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 70, height: 70)
                            
                            Text(initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.user.name)
                                .font(.headline)
                            Text(viewModel.user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Account Section
                Section("Account") {
                    NavigationLink {
                        EditProfileView(viewModel: viewModel)
                    } label: {
                        Label("Edit Profile", systemImage: "person")
                    }
                    
                    NavigationLink {
                        EditAddressView(viewModel: viewModel)
                    } label: {
                        Label("Shipping Address", systemImage: "mappin.and.ellipse")
                    }
                    
                    NavigationLink {
                        PaymentMethodsView(viewModel: viewModel)
                    } label: {
                        Label("Payment Methods", systemImage: "creditcard")
                    }
                }
                
                // Preferences Section
                Section("Preferences") {
                    Toggle(isOn: Binding(
                        get: { viewModel.notificationsEnabled },
                        set: { _ in viewModel.toggleNotifications() }
                    )) {
                        Label("Push Notifications", systemImage: "bell")
                    }
                    
                    Toggle(isOn: Binding(
                        get: { viewModel.emailUpdatesEnabled },
                        set: { _ in viewModel.toggleEmailUpdates() }
                    )) {
                        Label("Email Updates", systemImage: "envelope")
                    }
                }
                
                // Support Section
                Section("Support") {
                    Button {
                        // This would open the SDK chat
                    } label: {
                        Label("Chat with Support", systemImage: "message")
                    }
                    
                    Link(destination: URL(string: "https://example.com/faq")!) {
                        Label("FAQ", systemImage: "questionmark.circle")
                    }
                    
                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                }
                
                // Logout Section
                Section {
                    Button(role: .destructive) {
                        actionRouter.showLogoutAlert = true
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
            .overlay {
                if viewModel.showSaveConfirmation {
                    VStack {
                        Spacer()
                        Text("Changes saved")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.green)
                            .cornerRadius(25)
                            .padding(.bottom, 100)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: viewModel.showSaveConfirmation)
                }
            }
        }
    }
    
    private var initials: String {
        let names = viewModel.user.name.split(separator: " ")
        let firstInitial = names.first?.prefix(1) ?? ""
        let lastInitial = names.count > 1 ? names.last?.prefix(1) ?? "" : ""
        return "\(firstInitial)\(lastInitial)"
    }
}

// MARK: - Edit Profile View

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    
    var body: some View {
        Form {
            Section("Personal Information") {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.updateName(name)
                    viewModel.updateEmail(email)
                    viewModel.updatePhone(phone)
                    dismiss()
                }
            }
        }
        .onAppear {
            name = viewModel.user.name
            email = viewModel.user.email
            phone = viewModel.user.phone
        }
    }
}

// MARK: - Edit Address View

struct EditAddressView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    @State private var country: String = ""
    
    var body: some View {
        Form {
            Section("Address") {
                TextField("Street", text: $street)
                TextField("City", text: $city)
                TextField("State", text: $state)
                TextField("ZIP Code", text: $zipCode)
                    .keyboardType(.numberPad)
                TextField("Country", text: $country)
            }
        }
        .navigationTitle("Shipping Address")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let address = Address(
                        street: street,
                        city: city,
                        state: state,
                        zipCode: zipCode,
                        country: country
                    )
                    viewModel.updateAddress(address)
                    dismiss()
                }
            }
        }
        .onAppear {
            street = viewModel.user.address.street
            city = viewModel.user.address.city
            state = viewModel.user.address.state
            zipCode = viewModel.user.address.zipCode
            country = viewModel.user.address.country
        }
    }
}

// MARK: - Payment Methods View

struct PaymentMethodsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        List {
            if let payment = viewModel.user.paymentMethod {
                Section {
                    HStack {
                        Image(systemName: payment.type.icon)
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 40)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(payment.displayName)
                                .fontWeight(.medium)
                            Text("Expires \(payment.expiryDate)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.updatePaymentMethod(nil)
                    } label: {
                        Label("Remove Payment Method", systemImage: "trash")
                    }
                }
            } else {
                ContentUnavailableView(
                    "No Payment Method",
                    systemImage: "creditcard",
                    description: Text("Add a payment method to checkout faster")
                )
            }
            
            Section {
                Button {
                    // Would open add payment flow
                } label: {
                    Label("Add Payment Method", systemImage: "plus")
                }
            }
        }
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
        .environmentObject(ActionRouter.shared)
}
