//
//  HomeView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    topHeader
                    dailyPlanCard
                    quickActions
                    continueCard
                    recommendedCard
                    weeklyProgressCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.onTapNotifications()
                    } label: {
                        Image(systemName: "bell")
                    }
                    .accessibilityLabel("Notifications")
                }
            }
        }
    }

    // MARK: - Sections

    private var topHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(vm.greetingTitle)
                    .font(.title2.weight(.semibold))

                Text(vm.greetingSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .frame(width: 56, height: 56)

                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.blue)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var dailyPlanCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today’s plan")
                    .font(.headline)

                Spacer()

                Text(vm.todayProgressText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: vm.todayProgress)
                .tint(.blue)

            VStack(spacing: 10) {
                ForEach(vm.todayTasks) { task in
                    HomeTaskRow(task: task) {
                        vm.toggleTask(task)
                    }
                }
            }

            HStack(spacing: 10) {
                Label(vm.todayHint, systemImage: "sparkles")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    vm.startDailySession()
                } label: {
                    Text("Start")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 16)
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

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick start")
                .font(.headline)

            HStack(spacing: 12) {
                QuickActionCard(
                    title: "Topic Drill",
                    subtitle: "Pick a skill",
                    symbol: "cube.transparent",
                    tint: .blue
                ) {
                    vm.openTopicDrill()
                }

                QuickActionCard(
                    title: "Timed Set",
                    subtitle: "10–15 min",
                    symbol: "stopwatch",
                    tint: .purple
                ) {
                    vm.openTimedSet()
                }
            }

            HStack(spacing: 12) {
                QuickActionCard(
                    title: "Full Section",
                    subtitle: "SAT-style",
                    symbol: "doc.text",
                    tint: .orange
                ) {
                    vm.openFullSection()
                }

                QuickActionCard(
                    title: "Mistakes",
                    subtitle: "Fix weak spots",
                    symbol: "exclamationmark.triangle",
                    tint: .red
                ) {
                    vm.openMistakes()
                }
            }
        }
    }

    private var continueCard: some View {
        Group {
            if let session = vm.lastSession {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Continue")
                            .font(.headline)
                        Spacer()
                    }

                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.tertiarySystemFill))
                                .frame(width: 52, height: 52)
                            Image(systemName: session.symbol)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.blue)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.title)
                                .font(.subheadline.weight(.semibold))
                            Text("\(session.detail) • \(session.progressText)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            vm.continueLastSession()
                        } label: {
                            Text("Resume")
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(Color(.systemBackground)))
                        }
                        .buttonStyle(.plain)
                    }

                    ProgressView(value: session.progress)
                        .tint(.blue)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
            }
        }
    }

    private var recommendedCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recommended")
                    .font(.headline)
                Spacer()
            }

            VStack(spacing: 10) {
                ForEach(vm.recommendations) { rec in
                    RecommendationRow(rec: rec) {
                        vm.openRecommendation(rec)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var weeklyProgressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("This week")
                    .font(.headline)
                Spacer()
                Text(vm.weeklyMinutesText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: vm.weeklyProgress)
                .tint(.blue)

            HStack {
                Label(vm.weeklyHint, systemImage: "chart.line.uptrend.xyaxis")
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
}

// MARK: - Models

struct HomeTask: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    var isDone: Bool
}

struct HomeSession: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let detail: String
    let symbol: String
    let progress: Double

    var progressText: String {
        "\(Int((progress * 100).rounded()))%"
    }
}

struct Recommendation: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let symbol: String
    let level: String
}

// MARK: - Components

private struct HomeTaskRow: View {
    let task: HomeTask
    let onToggle: () -> Void

    var body: some View {
        Button {
            onToggle()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(task.isDone ? Color.green : Color.secondary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(task.subtitle)
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
        .buttonStyle(.plain)
    }
}

private struct RecommendationRow: View {
    let rec: Recommendation
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: 36, height: 36)

                    Image(systemName: rec.symbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.blue)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(rec.title)
                            .font(.subheadline.weight(.semibold))
                        Text(rec.level)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color(.tertiarySystemFill)))
                            .foregroundStyle(.secondary)
                    }

                    Text(rec.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemBackground))
            )
        }
        .buttonStyle(.plain)
    }
}

private struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: 40, height: 40)

                    Image(systemName: symbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(tint)
                }

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
