//
//  StatsModel.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import Foundation
import SwiftUI

enum StatsPeriod: CaseIterable {
    case week, month, all

    var title: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .all: return "All"
        }
    }
}

struct StatsOverview: Equatable {
    let solved: Int
    let accuracy: Double
    let timeMinutes: Int
    let avgSecondsPerQuestion: Int

    var accuracyText: String { "\(Int((accuracy * 100).rounded()))%" }

    var timeText: String {
        let h = timeMinutes / 60
        let m = timeMinutes % 60
        if h == 0 { return "\(m)m" }
        if m == 0 { return "\(h)h" }
        return "\(h)h \(m)m"
    }

    var avgPerQuestionText: String {
        let s = avgSecondsPerQuestion
        let m = s / 60
        let r = s % 60
        if m == 0 { return "\(r)s" }
        return "\(m)m \(r)s"
    }
}

struct ActivityPoint: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let minutes: Int
}

struct TopicAccuracy: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let accuracy: Double
    let solved: Int

    var accuracyText: String { "\(Int((accuracy * 100).rounded()))%" }
}

struct PaceStats: Equatable {
    let avgSecondsPerQuestion: Int
    let timedShare: Double          // 0...1
    let consistencyScore: Double    // 0...1

    var avgTimeText: String {
        let s = avgSecondsPerQuestion
        let m = s / 60
        let r = s % 60
        if m == 0 { return "\(r)s" }
        return "\(m)m \(r)s"
    }

    var timedSplitText: String {
        "\(Int((timedShare * 100).rounded()))% timed"
    }

    var consistencyScoreText: String {
        "\(Int((consistencyScore * 100).rounded()))%"
    }

    var consistencyHint: String {
        if consistencyScore >= 0.8 { return "Very stable. Great exam readiness." }
        if consistencyScore >= 0.65 { return "Decent. Reduce spikes by drilling weak types." }
        return "Unstable. Do more timed micro-sets."
    }
}

struct StreakStats: Equatable {
    let days: Int
    let best: Int
    let thisWeekSessions: Int

    var messageTitle: String {
        if days >= 7 { return "Strong streak" }
        if days >= 3 { return "Keep it alive" }
        return "Restart momentum"
    }

    var messageSubtitle: String {
        if days >= 7 { return "You’re building a habit that pays off." }
        if days >= 3 { return "One short session today keeps progress moving." }
        return "Start with 10 minutes — the hardest part is starting."
    }
}

enum InsightKind {
    case win, focus, tip

    var symbol: String {
        switch self {
        case .win: return "checkmark.seal.fill"
        case .focus: return "target"
        case .tip: return "lightbulb.fill"
        }
    }

    var tint: Color {
        switch self {
        case .win: return .green
        case .focus: return .orange
        case .tip: return .blue
        }
    }
}

struct Insight: Identifiable, Equatable {
    let id = UUID()
    let kind: InsightKind
    let title: String
    let subtitle: String
}
