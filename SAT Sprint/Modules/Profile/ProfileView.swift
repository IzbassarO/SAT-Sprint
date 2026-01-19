//
//  ProfileView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI
internal import Combine

// MARK: - View

struct ProfileView: View {
    @StateObject private var vm = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    statsGrid
                    progressCard
                    goalsCard
                    settingsCard
                    dangerZone
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.onTapEdit()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .accessibilityLabel("Edit profile")
                }
            }
            .sheet(isPresented: $vm.isEditPresented) {
                EditProfileSheet(
                    name: $vm.name,
                    targetScore: $vm.targetScore,
                    dailyGoalMinutes: $vm.dailyGoalMinutes,
                    onSave: { vm.saveEdits() }
                )
            }
            .alert("Reset progress?", isPresented: $vm.isResetAlertPresented) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) { vm.resetProgress() }
            } message: {
                Text("This will clear your local progress and streak.")
            }
        }
    }

    // MARK: - Sections

    private var header: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 64, height: 64)

                // Monogram fallback (no user image)
                Text(vm.monogram)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.primary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(vm.name)
                    .font(.title3.weight(.semibold))

                Text("SAT Math • Target \(vm.targetScore)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    Label("\(vm.streakDays) day streak", systemImage: "flame.fill")
                        .labelStyle(.titleAndIcon)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)

                    Label("\(vm.levelTitle)", systemImage: "sparkles")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var statsGrid: some View {
        HStack(spacing: 12) {
            StatPill(title: "Accuracy", value: vm.accuracyText, symbol: "scope")
            StatPill(title: "Solved", value: "\(vm.totalSolved)", symbol: "checkmark.circle")
            StatPill(title: "Time", value: vm.totalTimeText, symbol: "timer")
        }
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("This week")
                    .font(.headline)

                Spacer()

                Text("\(vm.weeklyMinutes) / \(vm.weeklyGoalMinutes) min")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: vm.weeklyProgress)
                .tint(Color.blue)

            HStack(spacing: 10) {
                Label(vm.weeklyHint, systemImage: "chart.line.uptrend.xyaxis")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    vm.startPractice()
                } label: {
                    Text("Practice")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().fill(Color.blue)
                        )
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

    private var goalsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Goals")
                    .font(.headline)
                Spacer()
            }

            GoalRow(
                title: "Daily practice",
                subtitle: "\(vm.dailyGoalMinutes) minutes",
                progress: vm.dailyProgress,
                trailing: vm.dailyProgressText
            )

            Divider()

            GoalRow(
                title: "Consistency",
                subtitle: "Keep your streak alive",
                progress: min(Double(vm.streakDays) / 14.0, 1.0),
                trailing: "\(vm.streakDays)d"
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.headline)

            VStack(spacing: 8) {
                SettingRow(
                    title: "Notifications",
                    subtitle: "Daily reminder",
                    symbol: "bell",
                    trailing: AnyView(
                        Toggle("", isOn: $vm.notificationsEnabled)
                            .labelsHidden()
                    )
                )

                SettingRow(
                    title: "Haptics",
                    subtitle: "Feedback on actions",
                    symbol: "iphone.radiowaves.left.and.right",
                    trailing: AnyView(
                        Toggle("", isOn: $vm.hapticsEnabled)
                            .labelsHidden()
                    )
                )

                SettingRow(
                    title: "Theme",
                    subtitle: vm.themeLabel,
                    symbol: "circle.lefthalf.filled",
                    trailing: AnyView(
                        Menu {
                            ForEach(ProfileTheme.allCases, id: \.self) { theme in
                                Button(theme.title) { vm.theme = theme }
                            }
                        } label: {
                            Text(vm.themeLabel)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                    )
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var dangerZone: some View {
        VStack(spacing: 10) {
            Button(role: .destructive) {
                vm.isResetAlertPresented = true
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset progress")
                    Spacer()
                }
                .font(.subheadline.weight(.semibold))
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
            }

            Button {
                vm.signOut()
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Sign out")
                    Spacer()
                }
                .font(.subheadline.weight(.semibold))
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
            }
            .foregroundStyle(.primary)
        }
        .padding(.top, 2)
    }
}

// MARK: - ViewModel (MVVM)

@MainActor
final class ProfileViewModel: ObservableObject {
    // User-facing
    @Published var name: String = "Izbassar"
    @Published var targetScore: Int = 780

    @Published var totalSolved: Int = 324
    @Published var accuracy: Double = 0.84

    @Published var totalMinutes: Int = 620
    @Published var weeklyMinutes: Int = 85
    @Published var weeklyGoalMinutes: Int = 120

    @Published var todayMinutes: Int = 10
    @Published var dailyGoalMinutes: Int = 20

    @Published var streakDays: Int = 6

    // Settings
    @Published var notificationsEnabled: Bool = true
    @Published var hapticsEnabled: Bool = true
    @Published var theme: ProfileTheme = .system

    // UI state
    @Published var isEditPresented: Bool = false
    @Published var isResetAlertPresented: Bool = false

    // Derived
    var monogram: String {
        let parts = name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? "I"
        let second = (parts.count > 1 ? parts[1].first : nil).map(String.init) ?? ""
        return (first + second).uppercased()
    }

    var accuracyText: String { "\(Int((accuracy * 100).rounded()))%" }

    var totalTimeText: String {
        let h = totalMinutes / 60
        let m = totalMinutes % 60
        if h == 0 { return "\(m)m" }
        if m == 0 { return "\(h)h" }
        return "\(h)h \(m)m"
    }

    var weeklyProgress: Double {
        guard weeklyGoalMinutes > 0 else { return 0 }
        return min(Double(weeklyMinutes) / Double(weeklyGoalMinutes), 1.0)
    }

    var dailyProgress: Double {
        guard dailyGoalMinutes > 0 else { return 0 }
        return min(Double(todayMinutes) / Double(dailyGoalMinutes), 1.0)
    }

    var dailyProgressText: String {
        "\(todayMinutes)/\(dailyGoalMinutes)m"
    }

    var weeklyHint: String {
        if weeklyProgress >= 1.0 { return "Goal reached — keep going for mastery." }
        if weeklyProgress >= 0.65 { return "Nice pace. A bit more to hit your goal." }
        return "Small sessions daily beat long rare sessions."
    }

    var levelTitle: String {
        switch totalSolved {
        case 0..<50: return "Beginner"
        case 50..<200: return "Builder"
        case 200..<500: return "Confident"
        default: return "Advanced"
        }
    }

    var themeLabel: String { theme.title }

    // Actions
    func onTapEdit() {
        isEditPresented = true
    }

    func saveEdits() {
        isEditPresented = false
        // TODO: Persist (UserDefaults / Keychain / DB)
    }

    func startPractice() {
        // TODO: Navigate to Practice tab / open first session
    }

    func resetProgress() {
        totalSolved = 0
        accuracy = 0
        totalMinutes = 0
        weeklyMinutes = 0
        todayMinutes = 0
        streakDays = 0
        // TODO: Clear storage (local DB/UserDefaults)
    }

    func signOut() {
        // TODO: Your auth flow
    }
}

// MARK: - Theme

enum ProfileTheme: CaseIterable {
    case system, light, dark

    var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

// MARK: - UI Components

private struct StatPill: View {
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
                .font(.headline.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

private struct GoalRow: View {
    let title: String
    let subtitle: String
    let progress: Double
    let trailing: String

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(trailing)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progress)
                .tint(Color.blue)
        }
    }
}

private struct SettingRow: View {
    let title: String
    let subtitle: String
    let symbol: String
    let trailing: AnyView

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
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            trailing
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

private struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var name: String
    @Binding var targetScore: Int
    @Binding var dailyGoalMinutes: Int

    let onSave: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("User") {
                    TextField("Name", text: $name)
                    Stepper("Target score: \(targetScore)", value: $targetScore, in: 400...800, step: 10)
                }

                Section("Goals") {
                    Stepper("Daily goal: \(dailyGoalMinutes) min", value: $dailyGoalMinutes, in: 5...180, step: 5)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}

#Preview {
    ProfileView()
}
