//
//  SAT_SprintApp.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 17.01.2026.
//

import SwiftUI

@main
struct SAT_SprintApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appState)
        }
    }
}
