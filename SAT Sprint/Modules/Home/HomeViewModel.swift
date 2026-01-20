//
//  HomeViewModel.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Header

    @Published var greetingTitle: String = "Today’s Focus"
    @Published var greetingSubtitle: String = "Let’s make progress in SAT Math"
    @Published var todayHint: String = "Short sessions beat long марафоны"

    // MARK: - Focus (big blue card)

    @Published var focusTitle: String = "Mini Set · Mixed Topics"
    @Published var focusMinutes: Int = 12
    @Published var focusQuestions: Int = 10

    var focusMinutesText: String { "\(focusMinutes) min" }
    var focusQuestionsText: String { "\(focusQuestions) questions" }

    // MARK: - Continue (two horizontal cards)

    @Published var lastSession: HomeSession? = .init(
        title: "Linear Equations",
        detail: "8/15 questions",
        progress: 8.0 / 15.0
    )

    @Published var secondSession: HomeSession? = .init(
        title: "Mini Set · Mixed",
        detail: "3/10 questions",
        progress: 3.0 / 10.0
    )

    // MARK: - Recommendations

    @Published var recommendations: [Recommendation] = [
        .init(title: "Systems of Equations", subtitle: "Algebra • 10 questions", symbol: "function", level: "MED"),
        .init(title: "Geometry Drills", subtitle: "Triangles & circles", symbol: "triangle", level: "EASY"),
        .init(title: "Word Problems", subtitle: "Translate text into equations", symbol: "text.book.closed", level: "HARD")
    ]

    // MARK: - Weekly activity

    @Published var weeklyProgress: Double = 0.45
    @Published var weeklyMinutesText: String = "45 questions this week"

    // MARK: - Actions (routing hooks)

    func onTapNotifications() {
        // TODO: open notifications screen
        print("Notifications tapped")
    }

    func startDailySession() {
        // TODO: start the recommended focus session
        print("Start Practice tapped")
    }

    func continueLastSession() {
        // TODO: resume lastSession
        print("Resume last session")
    }

    func openContinueAll() {
        // TODO: navigate to Continue list
        print("Open Continue -> View All")
    }

    func openWeeklyStats() {
        // TODO: open stats screen
        print("Open Weekly Stats")
    }

    func openTopic(_ name: String) {
        // TODO: open topic drill screen filtered by topic
        print("Open topic: \(name)")
    }

    func openSession(_ session: HomeSession) {
        // TODO: open a specific session card
        print("Open session: \(session.title)")
    }

    func openRecommendation(_ rec: Recommendation) {
        // TODO: open recommendation details/start
        print("Open recommendation: \(rec.title)")
    }
}

// MARK: - Models used by HomeView

struct HomeSession: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let detail: String
    let progress: Double
}

struct Recommendation: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let symbol: String
    let level: String
}
