//
//  RequestView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import SwiftUI

struct RequestView: View {
    let onContinue: () -> Void

    @StateObject private var vm = RequestViewModel()

    private let brandBlue = Color(red: 0.06, green: 0.20, blue: 0.55) // deep blue

    var body: some View {
        VStack(spacing: 0) {

            // Top content
            VStack(alignment: .leading, spacing: 8) {
                Text("Let’s personalize your practice")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)

                Text("Answer a few quick questions to set your starting point.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)

            Divider()
                .padding(.top, 12)
                .padding(.horizontal, 20)

            // Questions (3 blocks)
            VStack(spacing: 0) {
                QuestionBlock(
                    title: "Have you taken the SAT before?",
                    content: {
                        PillRow(
                            options: SatHistory.allCases,
                            selection: $vm.satHistory,
                            accent: brandBlue,
                            title: { $0.title }
                        )
                    }
                )

                Divider().padding(.horizontal, 20)

                QuestionBlock(
                    title: "Your current SAT Math level",
                    footer: "This helps us choose the right difficulty.",
                    content: {
                        PillRow(
                            options: UserLevel.allCases,
                            selection: $vm.level,
                            accent: brandBlue,
                            title: { $0.title }
                        )
                    }
                )

                Divider().padding(.leading, 20)

                QuestionBlock(
                    title: "Your target SAT Math score",
                    footer: "You can change this anytime later.",
                    content: {
                        PillRow(
                            options: TargetBand.allCases,
                            selection: $vm.targetBand,
                            accent: brandBlue,
                            title: { $0.title }
                        )
                    }
                )
            }
            .padding(.top, 6)

            Spacer(minLength: 0)

            // Bottom buttons
            VStack(spacing: 10) {
                Button {
                    vm.persist()
                    onContinue()
                } label: {
                    Text("Continue")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(brandBlue)
                        )
                        .foregroundStyle(.white)
                        .shadow(color: brandBlue.opacity(0.25), radius: 10, y: 6)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(.keyboard) // чтобы не прыгало при клавиатуре (хотя тут нет ввода)
    }
}

// MARK: - Building blocks

private struct QuestionBlock<Content: View>: View {
    let title: String
    var footer: String? = nil
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.top, 16)

            content

            if let footer {
                Text(footer)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

private struct PillRow<Option: Hashable>: View {
    let options: [Option]
    @Binding var selection: Option
    let accent: Color
    let title: (Option) -> String

    var body: some View {
        HStack(spacing: 10) {
            ForEach(options, id: \.self) { option in
                let isSelected = (selection == option)

                Button {
                    selection = option
                } label: {
                    Text(title(option))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(isSelected ? accent : Color(.systemBackground))
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.secondary.opacity(isSelected ? 0 : 0.25), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }

            Spacer(minLength: 0)
        }
    }
}
