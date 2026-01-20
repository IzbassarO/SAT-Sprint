//
//  StatsViewModel.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import Foundation
internal import Combine

@MainActor
final class StatsViewModel: ObservableObject {
    @Published var period: StatsPeriod = .week {
        didSet { loadMock(for: period) }
    }

    @Published var overview: StatsOverview = .init(solved: 0, accuracy: 0, timeMinutes: 0, avgSecondsPerQuestion: 0)
    @Published var activity: [ActivityPoint] = []
    @Published var topicAccuracy: [TopicAccuracy] = []
    @Published var pace: PaceStats = .init(avgSecondsPerQuestion: 0, timedShare: 0, consistencyScore: 0)
    @Published var streak: StreakStats = .init(days: 0, best: 0, thisWeekSessions: 0)

    @Published var insights: [Insight] = []

    init() {
        loadMock(for: period)
    }

    // MARK: - Derived text

    var activityHeaderText: String {
        switch period {
        case .week: return "\(activity.reduce(0) { $0 + $1.minutes }) min"
        case .month: return "Last 30 days"
        case .all: return "All time"
        }
    }

    var activityHint: String {
        let total = activity.reduce(0) { $0 + $1.minutes }
        if total >= 140 { return "Strong consistency. Keep the rhythm." }
        if total >= 70 { return "Good. Add 1 short session to level up." }
        return "Try 10–15 min daily to build momentum."
    }

    var topicHeaderText: String {
        let best = topicAccuracy.max(by: { $0.accuracy < $1.accuracy })
        return best.map { "Best: \($0.title)" } ?? "—"
    }

    // MARK: - Actions

    func refresh() {
        // TODO: Replace with real data source (DB / API).
        loadMock(for: period)
    }

    func openPractice() {
        // TODO: Hook to TabView selection / navigation.
    }

    // MARK: - Mock loader (replace later with repository)

    private func loadMock(for period: StatsPeriod) {
        // Обновляем по-разному, чтобы было видно переключение периодов.
        switch period {
        case .week:
            overview = .init(solved: 124, accuracy: 0.84, timeMinutes: 210, avgSecondsPerQuestion: 54)
            activity = [
                .init(label: "Mon", minutes: 15),
                .init(label: "Tue", minutes: 30),
                .init(label: "Wed", minutes: 20),
                .init(label: "Thu", minutes: 25),
                .init(label: "Fri", minutes: 10),
                .init(label: "Sat", minutes: 50),
                .init(label: "Sun", minutes: 60)
            ]
            topicAccuracy = [
                .init(title: "Algebra", accuracy: 0.86, solved: 42),
                .init(title: "Geometry", accuracy: 0.78, solved: 18),
                .init(title: "Word Problems", accuracy: 0.74, solved: 21),
                .init(title: "Functions", accuracy: 0.88, solved: 27),
                .init(title: "Stats", accuracy: 0.82, solved: 16)
            ]
            pace = .init(avgSecondsPerQuestion: 54, timedShare: 0.62, consistencyScore: 0.72)
            streak = .init(days: 6, best: 12, thisWeekSessions: 5)
            insights = [
                .init(kind: .win, title: "Functions is your strength", subtitle: "Accuracy 88% — keep speed up."),
                .init(kind: .focus, title: "Improve Word Problems", subtitle: "74% accuracy — do 1 drill daily."),
                .init(kind: .tip, title: "Pace is stable", subtitle: "Consistency score 72%. Aim for 80%+.")
            ]

        case .month:
            overview = .init(solved: 512, accuracy: 0.81, timeMinutes: 920, avgSecondsPerQuestion: 58)
            activity = [
                .init(label: "W1", minutes: 180),
                .init(label: "W2", minutes: 220),
                .init(label: "W3", minutes: 160),
                .init(label: "W4", minutes: 210)
            ]
            topicAccuracy = [
                .init(title: "Algebra", accuracy: 0.82, solved: 190),
                .init(title: "Geometry", accuracy: 0.77, solved: 86),
                .init(title: "Word Problems", accuracy: 0.72, solved: 110),
                .init(title: "Functions", accuracy: 0.85, solved: 78),
                .init(title: "Stats", accuracy: 0.83, solved: 48)
            ]
            pace = .init(avgSecondsPerQuestion: 58, timedShare: 0.55, consistencyScore: 0.64)
            streak = .init(days: 4, best: 12, thisWeekSessions: 4)
            insights = [
                .init(kind: .focus, title: "Word Problems still lagging", subtitle: "Main source of mistakes."),
                .init(kind: .tip, title: "Add 2 timed sets / week", subtitle: "Raise timed share to ~65%."),
                .init(kind: .win, title: "Good volume", subtitle: "500+ solved in 30 days.")
            ]

        case .all:
            overview = .init(solved: 2140, accuracy: 0.80, timeMinutes: 4620, avgSecondsPerQuestion: 60)
            activity = [
                .init(label: "2025", minutes: 1800),
                .init(label: "2026", minutes: 2820)
            ]
            topicAccuracy = [
                .init(title: "Algebra", accuracy: 0.79, solved: 900),
                .init(title: "Geometry", accuracy: 0.76, solved: 420),
                .init(title: "Word Problems", accuracy: 0.73, solved: 520),
                .init(title: "Functions", accuracy: 0.84, solved: 210),
                .init(title: "Stats", accuracy: 0.81, solved: 90)
            ]
            pace = .init(avgSecondsPerQuestion: 60, timedShare: 0.50, consistencyScore: 0.58)
            streak = .init(days: 2, best: 12, thisWeekSessions: 2)
            insights = [
                .init(kind: .tip, title: "Consistency is the lever", subtitle: "Small daily sessions beat occasional marathons."),
                .init(kind: .focus, title: "Geometry needs reps", subtitle: "Focus on formulas + diagrams."),
                .init(kind: .win, title: "Solid base", subtitle: "2k+ problems solved — you’re building mastery.")
            ]
        }
    }
}
