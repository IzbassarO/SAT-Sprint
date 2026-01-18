//
//  AppState.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var hasOnboarded: Bool {
        didSet {
            UserDefaults.standard.set(hasOnboarded, forKey: "hasOnboarded")
        }
    }
    
    init() {
        self.hasOnboarded = UserDefaults.standard.bool(forKey: "hasOnboarded")
    }

    // На будущее:
    // @Published var authState: AuthState = .unknown
    // @Published var subscription: SubscriptionState = .unknown
}
