//
//  RecommendationRow.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import SwiftUI

struct RecommendationRow: View {
    let rec: Recommendation
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {

                // Left icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: 40, height: 40)

                    Image(systemName: rec.symbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.blue)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(rec.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(rec.level)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color(.tertiarySystemFill))
                            )
                            .foregroundStyle(.secondary)
                    }

                    Text(rec.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
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

#Preview {
    RecommendationRow(rec: .init(title: "Checking", subtitle: "Sub Checking", symbol: "arrow.up", level: "Hard"), onTap: { })
}
