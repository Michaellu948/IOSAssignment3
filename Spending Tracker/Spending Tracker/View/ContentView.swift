//
//  ContentView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTab: Tabs = .home
    var body: some View {
        TabView(selection: $currentTab) {
            HomeView().tabItem { Tabs.home.tabContent }.tag(Tabs.home)
            SearchView().tabItem { Tabs.search.tabContent }.tag(Tabs.search)
            GraphView().tabItem { Tabs.graph.tabContent }.tag(Tabs.graph)
            SettingsView().tabItem { Tabs.settings.tabContent }.tag(Tabs.settings)
        }
    }
}

#Preview {
    ContentView()
}
