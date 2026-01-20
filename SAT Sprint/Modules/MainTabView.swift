//
//  MainTabView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

enum MainTab: Hashable {
    case home, stats, practice, profile
}

struct MainTabView: View {
    @State private var tab: MainTab = .home

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

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
        TabView(selection: $tab) {
            HomeView(tab: $tab)
                .tag(MainTab.home)
                .tabItem { Label("Home", systemImage: "house") }

            StatisticsView()
                .tag(MainTab.stats)
                .tabItem { Label("Stats", systemImage: "chart.bar") }

            PracticeView()
                .tag(MainTab.practice)
                .tabItem { Label("Practice", systemImage: "pencil.and.ruler") }

            ProfileView()
                .tag(MainTab.profile)
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    MainTabView()
}
