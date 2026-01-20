//
//  TopicAccuracyRow.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 19.01.2026.
//

import SwiftUI

struct TopicAccuracyRow: View {
    let topic: TopicAccuracy

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(topic.title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(topic.accuracyText) • \(topic.solved) solved")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: topic.accuracy)
                .tint(.blue)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

#Preview {
    TopicAccuracyRow(topic: .init(title: "Checking", accuracy: 70.0, solved: 12))
}
