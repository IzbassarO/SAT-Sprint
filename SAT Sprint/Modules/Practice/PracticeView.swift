//
//  PracticeView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI
internal import Combine

// MARK: - PracticeView
struct PracticeView: View {
    @StateObject private var vm = PracticeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerCard
                    modePicker
                    configCard
                    startButton
                    tipsCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $vm.isSessionPresented) {
                PracticeSessionView(
                    vm: PracticeSessionViewModel(config: vm.sessionConfig)
                )
            }
        }
    }

    // MARK: - Sections

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Train like the real SAT")
                .font(.title3.weight(.semibold))

            Text("Choose a mode, keep sessions short, then review mistakes. Consistency wins.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Label(vm.headerLeft, systemImage: "target")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Label(vm.headerRight, systemImage: "bolt.fill")
                    .font(.caption.weight(.semibold))
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

    private var modePicker: some View {
        HStack(spacing: 10) {
            ForEach(PracticeMode.allCases, id: \.self) { mode in
                Button {
                    vm.mode = mode
                } label: {
                    Text(mode.title)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(vm.mode == mode ? Color.blue : Color(.secondarySystemGroupedBackground))
                        )
                        .foregroundStyle(vm.mode == mode ? Color.white : Color.primary)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }

    private var configCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Setup")
                    .font(.headline)
                Spacer()
                Text(vm.modeSubtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            // Common toggles
            VStack(spacing: 10) {
                SettingInlineRow(
                    title: "Show explanations",
                    subtitle: "After each question",
                    symbol: "text.book.closed",
                    trailing: AnyView(
                        Toggle("", isOn: $vm.showExplanations)
                            .labelsHidden()
                    )
                )

                SettingInlineRow(
                    title: "Shuffle questions",
                    subtitle: "Mix order",
                    symbol: "shuffle",
                    trailing: AnyView(
                        Toggle("", isOn: $vm.shuffleQuestions)
                            .labelsHidden()
                    )
                )
            }

            Divider()

            // Mode-specific settings
            switch vm.mode {
            case .topic:
                topicConfig
            case .timed:
                timedConfig
            case .full:
                fullConfig
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var topicConfig: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Topic")
                .font(.subheadline.weight(.semibold))

            Menu {
                ForEach(PracticeTopic.allCases, id: \.self) { topic in
                    Button(topic.title) { vm.topic = topic }
                }
            } label: {
                HStack {
                    Text(vm.topic.title)
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.systemBackground))
                )
            }
            .buttonStyle(.plain)

            Stepper("Questions: \(vm.questionCount)", value: $vm.questionCount, in: 5...30, step: 1)
                .font(.subheadline.weight(.semibold))
        }
    }

    private var timedConfig: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Timed set")
                .font(.subheadline.weight(.semibold))

            Stepper("Questions: \(vm.questionCount)", value: $vm.questionCount, in: 5...25, step: 1)
                .font(.subheadline.weight(.semibold))

            Stepper("Time limit: \(vm.timeLimitMinutes) min", value: $vm.timeLimitMinutes, in: 5...30, step: 1)
                .font(.subheadline.weight(.semibold))

            HStack {
                Text("Difficulty")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Picker("", selection: $vm.difficulty) {
                    ForEach(PracticeDifficulty.allCases, id: \.self) { d in
                        Text(d.title).tag(d)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 190)
            }
        }
    }

    private var fullConfig: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Full section")
                .font(.subheadline.weight(.semibold))

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("SAT Math section simulation")
                        .font(.subheadline.weight(.semibold))
                    Text("Real pacing • mixed skills • review after")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "doc.text.fill")
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemBackground))
            )

            Stepper("Section length: \(vm.sectionPreset.title)", value: $vm.sectionPresetIndex, in: 0...(FullSectionPreset.allCases.count - 1))
                .font(.subheadline.weight(.semibold))

            Text("Preset: \(vm.sectionPreset.detail)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var startButton: some View {
        Button {
            vm.startSession()
        } label: {
            HStack {
                Spacer()
                Text("Start practice")
                    .font(.headline.weight(.semibold))
                Spacer()
            }
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.blue)
            )
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }

    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tips")
                .font(.headline)

            VStack(spacing: 8) {
                TipRow(text: "If you miss a question — don’t repeat it immediately. Review, then retry tomorrow.")
                TipRow(text: "Timed sets build calm. Start short (10–12 min) and increase gradually.")
                TipRow(text: "Your goal isn’t speed. It’s consistent accuracy under light pressure.")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

// MARK: - Practice Session (Demo screen)

struct PracticeSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: PracticeSessionViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                topBar

                VStack(alignment: .leading, spacing: 10) {
                    Text(vm.sessionTitle)
                        .font(.headline)

                    Text(vm.sessionSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                questionCard

                answersGrid

                Spacer()

                bottomControls
            }
            .padding(.top, 10)
            .background(Color(.systemGroupedBackground))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear { vm.startIfNeeded() }
            .onDisappear { vm.stopTimer() }
        }
    }

    private var topBar: some View {
        HStack(spacing: 10) {
            Label("Q \(vm.currentIndex + 1)/\(vm.total)", systemImage: "number")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Spacer()

            if let timeText = vm.timeRemainingText {
                Label(timeText, systemImage: "timer")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(vm.isTimeLow ? .red : .secondary)
            }
        }
        .padding(.horizontal, 16)
    }

    private var questionCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(vm.questionPrompt)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

            Text(vm.questionDetail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .padding(.horizontal, 16)
    }

    private var answersGrid: some View {
        VStack(spacing: 10) {
            ForEach(vm.choices) { choice in
                Button {
                    vm.select(choice)
                } label: {
                    HStack(spacing: 12) {
                        Text(choice.label)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 28, alignment: .leading)

                        Text(choice.text)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()

                        if vm.selectedID == choice.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.blue)
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.systemBackground))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private var bottomControls: some View {
        VStack(spacing: 10) {
            if vm.showExplanationBlock {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Explanation")
                        .font(.subheadline.weight(.semibold))
                    Text(vm.explanationText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
                .padding(.horizontal, 16)
            }

            HStack(spacing: 12) {
                Button {
                    vm.prev()
                } label: {
                    Text("Back")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.secondarySystemGroupedBackground))
                        )
                }
                .buttonStyle(.plain)
                .disabled(!vm.canGoBack)

                Button {
                    vm.nextOrFinish()
                } label: {
                    Text(vm.nextButtonTitle)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.blue)
                        )
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .disabled(!vm.canGoNext)
            }
            .padding(.horizontal, 16)

            Button(role: .destructive) {
                vm.finish()
            } label: {
                Text("End session")
                    .font(.caption.weight(.semibold))
            }
            .padding(.bottom, 10)
        }
    }
}

// MARK: - PracticeSessionViewModel

@MainActor
final class PracticeSessionViewModel: ObservableObject {
    let config: PracticeSessionConfig

    // Session state
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var selectedID: UUID? = nil
    @Published private(set) var isFinished: Bool = false

    // Timer
    @Published private(set) var timeRemaining: Int? = nil
    private var timer: Timer?

    init(config: PracticeSessionConfig) {
        self.config = config
        self.timeRemaining = config.timeLimitSeconds
    }

    var sessionTitle: String { config.title }
    var sessionSubtitle: String { config.subtitle }

    var total: Int { config.questionCount }

    var questionPrompt: String {
        // DEMO prompt
        switch currentIndex % 3 {
        case 0: return "Solve: 3x + 5 = 20"
        case 1: return "If f(x)=2x+1, find f(4)"
        default: return "A rectangle has area 48. If width is 6, what is length?"
        }
    }

    var questionDetail: String {
        "Choose the best answer."
    }

    var choices: [Choice] {
        // DEMO choices
        switch currentIndex % 3 {
        case 0:
            return [
                .init(label: "A", text: "x = 3"),
                .init(label: "B", text: "x = 4"),
                .init(label: "C", text: "x = 5"),
                .init(label: "D", text: "x = 6")
            ]
        case 1:
            return [
                .init(label: "A", text: "7"),
                .init(label: "B", text: "8"),
                .init(label: "C", text: "9"),
                .init(label: "D", text: "10")
            ]
        default:
            return [
                .init(label: "A", text: "6"),
                .init(label: "B", text: "7"),
                .init(label: "C", text: "8"),
                .init(label: "D", text: "9")
            ]
        }
    }

    var showExplanationBlock: Bool {
        config.showExplanations && selectedID != nil
    }

    var explanationText: String {
        // DEMO explanation
        "A quick explanation would appear here. Later you’ll replace this with real solution steps from your question bank."
    }

    var canGoBack: Bool { currentIndex > 0 }
    var canGoNext: Bool { selectedID != nil || !config.showExplanations }

    var nextButtonTitle: String {
        currentIndex == total - 1 ? "Finish" : "Next"
    }

    var timeRemainingText: String? {
        guard let t = timeRemaining else { return nil }
        let m = t / 60
        let s = t % 60
        return String(format: "%d:%02d", m, s)
    }

    var isTimeLow: Bool {
        guard let t = timeRemaining else { return false }
        return t <= 60
    }

    func startIfNeeded() {
        guard timer == nil else { return }
        guard timeRemaining != nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard var t = timeRemaining else { return }
        if t <= 0 {
            finish()
            return
        }
        t -= 1
        timeRemaining = t
    }

    func select(_ choice: Choice) {
        selectedID = choice.id
    }

    func prev() {
        guard canGoBack else { return }
        currentIndex -= 1
        selectedID = nil
    }

    func nextOrFinish() {
        if currentIndex == total - 1 {
            finish()
            return
        }
        currentIndex += 1
        selectedID = nil
    }

    func finish() {
        isFinished = true
        stopTimer()
        // TODO: Save attempt results, mistakes, time etc.
    }
}

// MARK: - Models

enum PracticeMode: CaseIterable {
    case topic, timed, full

    var title: String {
        switch self {
        case .topic: return "Topic"
        case .timed: return "Timed"
        case .full:  return "Full"
        }
    }
}

enum PracticeTopic: CaseIterable {
    case algebra, geometry, wordProblems, functions, stats

    var title: String {
        switch self {
        case .algebra: return "Algebra"
        case .geometry: return "Geometry"
        case .wordProblems: return "Word Problems"
        case .functions: return "Functions"
        case .stats: return "Statistics"
        }
    }
}

enum PracticeDifficulty: CaseIterable {
    case easy, mixed, hard

    var title: String {
        switch self {
        case .easy: return "Easy"
        case .mixed: return "Mixed"
        case .hard: return "Hard"
        }
    }
}

enum FullSectionPreset: CaseIterable {
    case mini, standard

    var title: String {
        switch self {
        case .mini: return "Mini"
        case .standard: return "Standard"
        }
    }

    var detail: String {
        switch self {
        case .mini: return "20 questions • 25 minutes"
        case .standard: return "44 questions • 70 minutes"
        }
    }

    var qCount: Int {
        switch self {
        case .mini: return 20
        case .standard: return 44
        }
    }

    var timeMinutes: Int {
        switch self {
        case .mini: return 25
        case .standard: return 70
        }
    }
}

struct PracticeSessionConfig: Equatable {
    let mode: PracticeMode
    let title: String
    let subtitle: String
    let questionCount: Int
    let timeLimitSeconds: Int?
    let showExplanations: Bool
    let shuffle: Bool
}

struct Choice: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let text: String
}

// MARK: - UI Helpers

private struct SettingInlineRow: View {
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

private struct TipRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.blue)
                .font(.system(size: 16, weight: .semibold))
                .padding(.top, 1)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

#Preview {
    PracticeView()
}
