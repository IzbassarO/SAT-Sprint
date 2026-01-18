//
//  MainTabView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            PracticeView()
                .tabItem { Label("Practice", systemImage: "pencil.and.ruler") }

            StatisticsView()
                .tabItem { Label("Stats", systemImage: "chart.bar") }

            AchievementsView()
                .tabItem { Label("Achievements", systemImage: "rosette") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    MainTabView()
}
