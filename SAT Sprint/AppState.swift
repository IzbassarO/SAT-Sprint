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
    enum Flow: String {
        case onboarding
        case intake
        case diagnostic
        case main
    }

    @AppStorage("flow") private var flowRaw: String = Flow.onboarding.rawValue
    @Published var flow: Flow = .onboarding

    @AppStorage("onboardingSeen") var onboardingSeen: Bool = false
    @AppStorage("intakeDone") var intakeDone: Bool = false
    @AppStorage("diagnosticDone") var diagnosticDone: Bool = false
    @AppStorage("diagnosticSkipped") var diagnosticSkipped: Bool = false

    init() {
        // восстановление state при запуске
        recomputeFlow()
    }

    func recomputeFlow() {
        if !onboardingSeen {
            flow = .onboarding
        } else if !intakeDone {
            flow = .intake
        } else if !diagnosticDone && !diagnosticSkipped {
            flow = .diagnostic
        } else {
            flow = .main
        }
    }

    // MARK: - Events

    func finishOnboarding() {
        onboardingSeen = true
        recomputeFlow()
    }

    func finishIntake() {
        intakeDone = true
        recomputeFlow()
    }

    func finishDiagnostic() {
        diagnosticDone = true
        recomputeFlow()
    }

    func skipDiagnostic() {
        diagnosticSkipped = true
        recomputeFlow()
    }
}
