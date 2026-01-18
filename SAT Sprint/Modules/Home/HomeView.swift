//
//  HomeView.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            Text("Home")
                .navigationTitle("Sprint")
        }
    }
}

#Preview {
    HomeView()
}
