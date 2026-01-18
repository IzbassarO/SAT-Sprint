//
//  PageDots.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

struct PageDots: View {
    let count: Int
    let index: Int
    let accent: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { i in
                Capsule(style: .continuous)
                    .fill(i == index ? accent : Color.black.opacity(0.12))
                    .frame(width: i == index ? 30 : 10, height: 6)
                    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: index)
            }
        }
    }
}
