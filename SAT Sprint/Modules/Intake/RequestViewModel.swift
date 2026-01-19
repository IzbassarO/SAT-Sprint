//
//  RequestViewModel.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
final class RequestViewModel: ObservableObject {
    @Published var satHistory: SatHistory = .never
    @Published var level: UserLevel = .beginner
    @Published var targetBand: TargetBand = .band600_700

    func persist() {
        UserDefaults.standard.set(satHistory.rawValue, forKey: "intake_satHistory")
        UserDefaults.standard.set(level.rawValue, forKey: "intake_level")
        UserDefaults.standard.set(targetBand.rawValue, forKey: "intake_targetBand")
    }
}

enum SatHistory: String, CaseIterable {
    case never, once, many

    var title: String {
        switch self {
        case .never: return "Never"
        case .once: return "Once"
        case .many: return "Multiple times"
        }
    }
}

enum UserLevel: String, CaseIterable {
    case beginner, intermediate, advanced

    var title: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
}

enum TargetBand: String, CaseIterable {
    case band400_600, band600_700, band700_800

    var title: String {
        switch self {
        case .band400_600: return "400–600"
        case .band600_700: return "600–700"
        case .band700_800: return "700–800"
        }
    }
}
