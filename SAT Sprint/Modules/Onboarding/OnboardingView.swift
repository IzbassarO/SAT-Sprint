//
//  OnboardingView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void
    @StateObject private var vm = OnboardingViewModel()
    
    private let secondaryOnHero = Color.white.opacity(0.82)

    var body: some View {
        GeometryReader { geo in
            let safeTop = geo.safeAreaInsets.top
            let safeBottom = geo.safeAreaInsets.bottom
            let fullH = geo.size.height + safeTop + safeBottom

            ZStack {
                Image(vm.pages[vm.index].imageName)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFill()
                    .frame(width: geo.size.width, height: fullH)
                    .clipped()
                    .ignoresSafeArea(.all)

                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .clear, location: 0.55),
                        .init(color: .black.opacity(0.20), location: 0.78),
                        .init(color: .black.opacity(0.60), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                .allowsHitTesting(false)
                
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        BrandLockup(assetName: "brand_lockup", height: 26)
                            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)

                        Spacer()

                        Button("Skip") { onFinish() }
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.16), in: Capsule(style: .continuous))
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.22), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 12)

                    Spacer()

                    VStack(alignment: .leading, spacing: 10) {
                        Text(vm.pages[vm.index].title)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text(vm.pages[vm.index].subtitle)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(secondaryOnHero)
                            .lineSpacing(3)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 14)

                    HStack(alignment: .center) {
                        PageDots(count: vm.pages.count, index: vm.index)

                        Spacer()

                        Button { vm.back() } label: {
                            Image("back_blob")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .opacity(vm.isFirst ? 0.35 : 1)
                        }
                        .buttonStyle(.plain)
                        .disabled(vm.isFirst)
                        .padding(.trailing, 6)

                        Button {
                            if vm.isLast { onFinish() }
                            else { withAnimation(.easeInOut(duration: 0.25)) { vm.next() } }
                        } label: {
                            Image("next_blob")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
                }
                .padding(.top, safeTop)
                .padding(.bottom, safeBottom)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

//#Preview {
//    OnboardingView()
//}
