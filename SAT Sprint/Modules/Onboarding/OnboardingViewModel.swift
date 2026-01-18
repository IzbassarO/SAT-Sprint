//
//  OnboardingViewModel.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var index: Int = 0

    let pages: [OnboardingPage] = [
        .init(
            imageName: "onb_1",
            title: "Smart SAT Prep",
            subtitle: "Short practice. Clear progress."
        ),
        .init(
            imageName: "onb_2",
            title: "Practice Modes",
            subtitle: "Drills, timed sets, full sections."
        ),
        .init(
            imageName: "onb_3",
            title: "Build Confidence",
            subtitle: "Start easy. Add timing later."
        )
    ]
    var isFirst: Bool { index == 0 }
    var isLast: Bool { index == pages.count - 1 }

    func next() {
        guard !isLast else { return }
        index += 1
    }
    
    func back() {
        guard !isFirst else { return }
        index -= 1
    }
}
