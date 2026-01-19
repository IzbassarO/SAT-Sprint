//
//  StatisticsView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI
import Charts
internal import Combine

// MARK: - StatsView

struct StatisticsView: View {
    @StateObject private var vm = StatsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    periodPicker
                    overviewGrid
                    weeklyChartCard
                    accuracyByTopicCard
                    paceCard
                    streakCard
                    insightsCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.refresh()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .accessibilityLabel("Refresh stats")
                }
            }
        }
    }

    // MARK: - Sections

    private var periodPicker: some View {
        HStack(spacing: 10) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Button {
                    vm.period = period
                } label: {
                    Text(period.title)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(vm.period == period ? Color.blue : Color(.secondarySystemGroupedBackground))
                        )
                        .foregroundStyle(vm.period == period ? Color.white : Color.primary)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }

    private var overviewGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.headline)

            HStack(spacing: 12) {
                StatTile(title: "Solved", value: "\(vm.overview.solved)", symbol: "checkmark.circle")
                StatTile(title: "Accuracy", value: vm.overview.accuracyText, symbol: "scope")
            }

            HStack(spacing: 12) {
                StatTile(title: "Time", value: vm.overview.timeText, symbol: "timer")
                StatTile(title: "Avg / Q", value: vm.overview.avgPerQuestionText, symbol: "bolt")
            }
        }
    }

    private var weeklyChartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Activity")
                    .font(.headline)
                Spacer()
                Text(vm.activityHeaderText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Chart(vm.activity) { item in
                BarMark(
                    x: .value("Day", item.label),
                    y: .value("Minutes", item.minutes)
                )
            }
            .frame(height: 160)

            HStack {
                Label(vm.activityHint, systemImage: "chart.bar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var accuracyByTopicCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Accuracy by topic")
                    .font(.headline)
                Spacer()
                Text(vm.topicHeaderText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 10) {
                ForEach(vm.topicAccuracy) { topic in
                    TopicAccuracyRow(topic: topic)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var paceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pace")
                .font(.headline)

            HStack(spacing: 12) {
                InfoCard(
                    title: "Avg time per question",
                    value: vm.pace.avgTimeText,
                    symbol: "stopwatch"
                )

                InfoCard(
                    title: "Timed vs Untimed",
                    value: vm.pace.timedSplitText,
                    symbol: "slider.horizontal.3"
                )
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pace consistency")
                        .font(.subheadline.weight(.semibold))
                    Text(vm.pace.consistencyHint)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(vm.pace.consistencyScoreText)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: vm.pace.consistencyScore)
                .tint(.blue)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Streak")
                    .font(.headline)
                Spacer()
                Label("\(vm.streak.days) days", systemImage: "flame.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
            }

            HStack(spacing: 12) {
                InfoCard(title: "Best streak", value: "\(vm.streak.best) days", symbol: "trophy")
                InfoCard(title: "This week", value: "\(vm.streak.thisWeekSessions) sessions", symbol: "calendar")
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.streak.messageTitle)
                        .font(.subheadline.weight(.semibold))
                    Text(vm.streak.messageSubtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    vm.openPractice()
                } label: {
                    Text("Practice")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.blue))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var insightsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.headline)

            VStack(spacing: 10) {
                ForEach(vm.insights) { insight in
                    InsightRow(insight: insight)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

// MARK: - ViewModel

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

// MARK: - Types

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

// MARK: - UI Components

private struct StatTile: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: symbol)
                    .foregroundStyle(.secondary)
                Text(title)
                    .foregroundStyle(.secondary)
            }
            .font(.caption)

            Text(value)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

private struct InfoCard: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 36, height: 36)

                Image(systemName: symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.semibold))
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

private struct TopicAccuracyRow: View {
    let topic: TopicAccuracy

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(topic.title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(topic.accuracyText) • \(topic.solved) solved")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: topic.accuracy)
                .tint(.blue)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

private struct InsightRow: View {
    let insight: Insight

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 36, height: 36)

                Image(systemName: insight.kind.symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(insight.kind.tint)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(insight.title)
                    .font(.subheadline.weight(.semibold))
                Text(insight.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}


#Preview {
    StatisticsView()
}
