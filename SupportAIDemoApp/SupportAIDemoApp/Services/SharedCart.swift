//
//  SharedCart.swift
//  SupportAIDemoApp
//
//  Created by milad yalda on 2026-02-18.
//

// MARK: - Shared Cart

final class SharedCart {
    static let shared = SharedCart()
    let viewModel = CartViewModel()
    private init() {}
}
