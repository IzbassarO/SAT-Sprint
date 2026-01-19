//
//  DiagnosticView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import SwiftUI

struct DiagnosticView: View {
    let onStart: () -> Void
    let onNotNow: () -> Void

    @StateObject private var vm = DiagnosticViewModel()

    private let brandBlue = Color(red: 0.06, green: 0.20, blue: 0.55)

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Text("Quick diagnostic?")
                    .font(.title.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.top)

                Text("A short 6–8 minute check helps us personalize your practice plan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 34)
            }
            .padding(.top, 10)

            // Card with bullets
            VStack(alignment: .leading, spacing: 14) {
                BulletRow("Takes about 6–8 minutes")
                BulletRow("Optional and not graded")
                BulletRow("Does not affect any score")
                BulletRow("Helps set starting difficulty and daily plan")
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)
            .padding(.top, 26)

            Spacer(minLength: 0)

            Divider()
                .padding(.horizontal, 20)
                .padding(.bottom, 14)

            // Bottom buttons
            VStack(spacing: 10) {
                Button {
                    vm.markOffered()
                    onStart()
                } label: {
                    Text("Start")
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

                Button {
                    vm.markOffered()
                    onNotNow()
                } label: {
                    Text("Not now")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.secondary.opacity(0.35), lineWidth: 1)
                        )
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)

                Text("You can run the diagnostic anytime later from Practice.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)
        }
        .background(Color(.systemBackground))
        // важно: никаких navigationTitle / toolbar
    }
}

private struct BulletRow: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text("•")
                .foregroundStyle(.secondary)
                .padding(.leading, 2)

            Text(text)
                .font(.body)
                .foregroundStyle(.primary)

            Spacer(minLength: 0)
        }
    }
}

#Preview {
    DiagnosticView(onStart: {}, onNotNow: {})
}
