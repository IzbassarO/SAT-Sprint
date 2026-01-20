//
//  FocusCard.swift.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import SwiftUI

struct FocusCard: View {
    let title: String
    let minutes: String
    let questions: String
    let onStart: () -> Void

    private let blue1 = Color(red: 0.06, green: 0.35, blue: 0.98)
    private let blue2 = Color(red: 0.03, green: 0.20, blue: 0.80)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(colors: [blue1, blue2], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(color: .black.opacity(0.10), radius: 18, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 14) {
                Text("Recommended")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))

                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: 12) {
                    Label(minutes, systemImage: "clock")
                        .foregroundStyle(.white.opacity(0.9))
                    Text("•")
                        .foregroundStyle(.white.opacity(0.7))
                    Text(questions)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .font(.caption.weight(.semibold))
                
                Spacer()
                
                Button(action: onStart) {
                    Text("Start Practice")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white)
                        )
                        .foregroundStyle(blue2)
                }
                .buttonStyle(.plain)
            }
            .padding(18)

            // target icon top-right
            ZStack {
                Circle().fill(.white.opacity(0.18))
                    .frame(width: 44, height: 44)
                Image(systemName: "scope")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(16)
        }
        .frame(height: 180)
    }
}

#Preview {
    FocusCard(title: "Checking", minutes: "10", questions: "How?", onStart: { })
}
