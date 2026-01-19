//
//  AppRootView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import Foundation
import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            switch appState.flow {
            case .onboarding:
                OnboardingView {
                    appState.finishOnboarding()
                }
                
            case .intake:
                RequestView(
                    onContinue: { appState.finishIntake() }
                )
                
            case .diagnostic:
                DiagnosticView(
                    onStart: {  },
                    onNotNow:  { appState.skipDiagnostic() }
                )
                
            case .main:
                MainTabView()
            }
        }
    }
}
