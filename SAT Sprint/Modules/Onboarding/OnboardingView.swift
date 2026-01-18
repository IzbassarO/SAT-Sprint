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

    private let accent = Color(red: 0.06, green: 0.20, blue: 0.55)
    private let secondary = Color.black.opacity(0.55)
    private let surface = Color(red: 0.95, green: 0.96, blue: 0.98)

    var body: some View {
        VStack(spacing: 0) {

            // Top bar: Brand + Skip
            HStack(spacing: 12) {
                BrandLockup(assetName: "brand_lockup", height: 26)
                Spacer()

                Button("Skip") {
                    onFinish()
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(secondary)
                .contentShape(Rectangle())
            }
            .padding(.horizontal, 12)
            .padding(.top, 14)
            .padding(.bottom, 10)
            
            ZStack {
                OnboardingPageContent(
                    page: vm.pages[vm.index],
                    accent: accent,
                    secondary: secondary,
                    surface: surface
                )
            }

            Spacer(minLength: 0)

            HStack(alignment: .center) {
                PageDots(count: vm.pages.count, index: vm.index, accent: accent)

                Spacer()
                
                Button {
                    vm.back()
                } label: {
                    Image("back_blob")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 6)
                
                Button {
                    if vm.isLast {
                        onFinish()
                    } else {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            vm.next()
                        }
                    }
                } label: {
                    Image("next_blob")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 14)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

private struct OnboardingPageContent: View {
    let page: OnboardingPage
    let accent: Color
    let secondary: Color
    let surface: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            OnboardingImageCard(
                imageName: page.imageName,
                accent: accent,
                surface: surface
            )
            .padding(.top, 30)

            VStack(alignment: .leading, spacing: 12) {
                Text(page.title)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 16)

                Text(page.subtitle)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(3)
            }

            Spacer(minLength: 10)
        }
        .padding(.horizontal, 12)
    }
}

//#Preview {
//    OnboardingView()
//}
