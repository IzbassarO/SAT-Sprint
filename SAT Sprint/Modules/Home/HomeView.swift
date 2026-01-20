//
//  HomeView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI
import Charts

struct HomeView: View {
    @Binding var tab: MainTab
    @StateObject private var vm = HomeViewModel()

    // Reuse Stats "Activity" data + header/hint
    @StateObject private var statsVM = StatsViewModel()

    // Brand
    private let heroBlue = Color(red: 0.06, green: 0.20, blue: 0.55)
    private let heroBlue2 = Color(red: 0.08, green: 0.33, blue: 0.95)

    // Layout tuning
    private let contentCorner: CGFloat = 28

    // Preview-friendly init
    init(tab: Binding<MainTab> = .constant(.home)) {
        self._tab = tab
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                contentContainer
                    .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: -2)
                    .padding(.horizontal, 0)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Content Container (white rounded sheet)
    private var contentContainer: some View {
        VStack(alignment: .leading, spacing: 14) {
            todaysFocusSection
            continueSection
            quickStartSection
            recommendedSection
            weeklyActivitySection
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 28)
    }

    // MARK: - Sections

    private var todaysFocusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Focus")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .padding()

            FocusCard(
                title: vm.focusTitle,
                minutes: vm.focusMinutesText,
                questions: vm.focusQuestionsText,
                onStart: { vm.startDailySession() }
            )
        }
    }

    private var continueSection: some View {
        Group {
            if let session = vm.lastSession {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Continue")
                            .font(.title3.weight(.semibold))
                        Spacer()
                        Button("View All") { vm.openContinueAll() }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.blue)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ContinueMiniCard(
                                title: session.title,
                                detail: session.detail,
                                progress: session.progress
                            ) { vm.continueLastSession() }

                            if let session2 = vm.secondSession {
                                ContinueMiniCard(
                                    title: session2.title,
                                    detail: session2.detail,
                                    progress: session2.progress
                                ) { vm.openSession(session2) }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
    }

    private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Start")
                .font(.title3.weight(.semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    QuickActionPill(title: "Algebra", tint: .blue) { vm.openTopic("Algebra") }
                    QuickActionPill(title: "Functions", tint: .purple) { vm.openTopic("Functions") }
                    QuickActionPill(title: "Geometry", tint: .green) { vm.openTopic("Geometry") }
                    QuickActionPill(title: "Word Problems", tint: .orange) { vm.openTopic("Word Problems") }
                    QuickActionPill(title: "Data", tint: .mint) { vm.openTopic("Data") }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recommended")
                .font(.title3.weight(.semibold))

            VStack(spacing: 10) {
                ForEach(vm.recommendations) { rec in
                    RecommendationRow(rec: rec) { vm.openRecommendation(rec) }
                }
            }
        }
    }

    // ✅ Weekly Activity uses the SAME chart as StatisticsView.Activity
    // ✅ View Stats switches to Stats tab
    private var weeklyActivitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Weekly Activity")
                    .font(.title3.weight(.semibold))
                Spacer()
                Button("View Stats") {
                    tab = .stats
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.blue)
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Activity").font(.headline)
                    Spacer()
                    Text(statsVM.activityHeaderText)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Chart(statsVM.activity) { item in
                    BarMark(
                        x: .value("Day", item.label),
                        y: .value("Minutes", item.minutes)
                    )
                }
                .frame(height: 160)

                HStack {
                    Label(statsVM.activityHint, systemImage: "chart.bar")
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
}

//#Preview {
//    MainTabView()
//}

#Preview {
    HomeView()
}
