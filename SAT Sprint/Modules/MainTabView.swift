//
//  MainTabView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

struct MainTabView: View {

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.clear

        // Remove the hairline/shadow
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

        // Optional: make icons/text a bit cleaner
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.label
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            StatisticsView()
                .tabItem { Label("Stats", systemImage: "chart.bar") }

            PracticeView()
                .tabItem { Label("Practice", systemImage: "pencil.and.ruler") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    MainTabView()
}
