//
//  ContinueMiniCard.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import SwiftUI

struct ContinueMiniCard: View {
    let title: String
    let detail: String
    let progress: Double
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                }

                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                ProgressView(value: progress)
                    .tint(.blue)

                Text("\(Int((progress * 100).rounded()))% complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .frame(width: 260, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContinueMiniCard(title: "Checking", detail: "Checking", progress: 80.0, onTap: { })
}
