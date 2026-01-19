//
//  HomeViewModel.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import Foundation
internal import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    // Greeting
    @Published var userName: String = "Izbassar"

    // Daily plan
    @Published var todayMinutesDone: Int = 10
    @Published var todayMinutesGoal: Int = 20
    @Published var todayTasks: [HomeTask] = [
        .init(title: "Warm-up", subtitle: "3 easy questions", isDone: true),
        .init(title: "Core practice", subtitle: "10 mixed questions", isDone: false),
        .init(title: "Review mistakes", subtitle: "2 explanations", isDone: false),
    ]

    // Continue
    @Published var lastSession: HomeSession? = .init(
        title: "Timed Set",
        detail: "Algebra • 12 questions",
        symbol: "stopwatch",
        progress: 0.55
    )

    // Recommendations
    @Published var recommendations: [Recommendation] = [
        .init(title: "Linear equations", subtitle: "Your accuracy is trending down", symbol: "function", level: "Medium"),
        .init(title: "Word problems", subtitle: "Fast win with patterns", symbol: "text.book.closed", level: "Easy"),
        .init(title: "Quadratics", subtitle: "Important for SAT", symbol: "x.squareroot", level: "Hard")
    ]

    // Weekly
    @Published var weeklyMinutes: Int = 85
    @Published var weeklyGoalMinutes: Int = 120

    var greetingTitle: String {
        // Можно позже заменить на real greeting by time
        "Welcome back, \(userName)"
    }

    var greetingSubtitle: String {
        "Let’s keep momentum — short sessions, real progress."
    }

    var todayProgress: Double {
        guard todayMinutesGoal > 0 else { return 0 }
        return min(Double(todayMinutesDone) / Double(todayMinutesGoal), 1.0)
    }

    var todayProgressText: String {
        "\(todayMinutesDone) / \(todayMinutesGoal) min"
    }

    var todayHint: String {
        if todayProgress >= 1.0 { return "Goal reached. Optional: do 5 more for confidence." }
        if todayProgress >= 0.5 { return "Nice. Finish a short set to lock it in." }
        return "Start with warm-up. Don’t overthink it."
    }

    var weeklyProgress: Double {
        guard weeklyGoalMinutes > 0 else { return 0 }
        return min(Double(weeklyMinutes) / Double(weeklyGoalMinutes), 1.0)
    }

    var weeklyMinutesText: String {
        "\(weeklyMinutes) / \(weeklyGoalMinutes) min"
    }

    var weeklyHint: String {
        if weeklyProgress >= 1.0 { return "Weekly goal achieved — maintain the streak." }
        if weeklyProgress >= 0.65 { return "Almost there. Two short sessions will do it." }
        return "Aim for 10–15 minutes per day."
    }

    // Actions (hooks for navigation)
    func onTapNotifications() {
        // TODO: open notifications/settings
    }

    func startDailySession() {
        // TODO: navigate to Practice tab -> start recommended daily session
    }

    func toggleTask(_ task: HomeTask) {
        guard let idx = todayTasks.firstIndex(where: { $0.id == task.id }) else { return }
        todayTasks[idx].isDone.toggle()

        // маленькая логика прогресса (пример)
        let doneCount = todayTasks.filter { $0.isDone }.count
        todayMinutesDone = min(todayMinutesGoal, doneCount * 6) // условно
    }

    func continueLastSession() {
        // TODO: resume session
    }

    func openTopicDrill() {
        // TODO: navigate to topic picker
    }

    func openTimedSet() {
        // TODO: open timed set config
    }

    func openFullSection() {
        // TODO: open full SAT math section
    }

    func openMistakes() {
        // TODO: open mistakes/review list
    }

    func openRecommendation(_ rec: Recommendation) {
        // TODO: open recommended drill
    }
}
