//
//  DiagnosticViewModel.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import Foundation
internal import Combine

@MainActor
final class DiagnosticViewModel: ObservableObject {

    // например: чтобы не показывать экран снова
    func markOffered() {
        UserDefaults.standard.set(true, forKey: "diagnostic_offered")
    }
}
