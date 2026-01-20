//
//  StatisticsView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI
import Charts

// MARK: - StatsView

import SwiftUI
import Charts

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
                    Button { vm.refresh() } label: {
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
            Text("Overview").font(.headline)

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
                Text("Activity").font(.headline)
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
                Text("Accuracy by topic").font(.headline)
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
            Text("Pace").font(.headline)

            HStack(spacing: 12) {
                InfoCard(title: "Avg time per question", value: vm.pace.avgTimeText, symbol: "stopwatch")
                InfoCard(title: "Timed vs Untimed", value: vm.pace.timedSplitText, symbol: "slider.horizontal.3")
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pace consistency").font(.subheadline.weight(.semibold))
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
                Text("Streak").font(.headline)
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
                    Text(vm.streak.messageTitle).font(.subheadline.weight(.semibold))
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
            Text("Insights").font(.headline)

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


#Preview {
    StatisticsView()
}
