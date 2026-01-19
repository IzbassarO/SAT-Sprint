//
//  PracticeViewModel.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import Foundation
internal import Combine

@MainActor
final class PracticeViewModel: ObservableObject {
    @Published var mode: PracticeMode = .topic

    // Common config
    @Published var showExplanations: Bool = true
    @Published var shuffleQuestions: Bool = true

    // Mode config
    @Published var topic: PracticeTopic = .algebra
    @Published var questionCount: Int = 10

    @Published var timeLimitMinutes: Int = 12
    @Published var difficulty: PracticeDifficulty = .mixed

    @Published var sectionPresetIndex: Int = 0

    // UI
    @Published var isSessionPresented: Bool = false

    var sectionPreset: FullSectionPreset { FullSectionPreset.allCases[sectionPresetIndex] }

    var modeSubtitle: String {
        switch mode {
        case .topic: return "Focus one skill"
        case .timed: return "Short exam pressure"
        case .full:  return "Full SAT-style"
        }
    }

    var headerLeft: String {
        switch mode {
        case .topic: return "Build fundamentals"
        case .timed: return "Train pacing"
        case .full:  return "Simulate test"
        }
    }

    var headerRight: String {
        switch mode {
        case .topic: return "\(questionCount) questions"
        case .timed: return "\(questionCount) Q • \(timeLimitMinutes)m"
        case .full:  return "\(sectionPreset.qCount) Q • \(sectionPreset.timeMinutes)m"
        }
    }

    var sessionConfig: PracticeSessionConfig {
        switch mode {
        case .topic:
            return .init(
                mode: mode,
                title: "Topic Drill",
                subtitle: topic.title,
                questionCount: questionCount,
                timeLimitSeconds: nil,
                showExplanations: showExplanations,
                shuffle: shuffleQuestions
            )
        case .timed:
            return .init(
                mode: mode,
                title: "Timed Set",
                subtitle: "\(difficulty.title) • \(questionCount) questions",
                questionCount: questionCount,
                timeLimitSeconds: timeLimitMinutes * 60,
                showExplanations: showExplanations,
                shuffle: shuffleQuestions
            )
        case .full:
            return .init(
                mode: mode,
                title: "Full Section",
                subtitle: sectionPreset.detail,
                questionCount: sectionPreset.qCount,
                timeLimitSeconds: sectionPreset.timeMinutes * 60,
                showExplanations: showExplanations,
                shuffle: shuffleQuestions
            )
        }
    }

    func startSession() {
        isSessionPresented = true
    }
}
