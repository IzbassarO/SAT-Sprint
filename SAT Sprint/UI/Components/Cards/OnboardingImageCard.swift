//
//  OnboardingImageCard.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

struct OnboardingImageCard: View {
    let imageName: String
    let accent: Color
    let surface: Color
    var maxHeight: CGFloat = 420

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = min(maxHeight, w * 0.78)

            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            }
            .frame(width: w, height: h)
        }
        .frame(height: 320)
    }
}
