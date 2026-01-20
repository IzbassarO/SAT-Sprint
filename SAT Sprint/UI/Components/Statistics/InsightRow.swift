//
//  InsightRow.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import SwiftUI

struct InsightRow: View {
    let insight: Insight

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 36, height: 36)

                Image(systemName: insight.kind.symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(insight.kind.tint)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(insight.title)
                    .font(.subheadline.weight(.semibold))
                Text(insight.subtitle)
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
}

#Preview {
    InsightRow(insight: .init(kind: .focus, title: "Checking", subtitle: "Checking"))
}
