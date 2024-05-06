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
            Text("Home").tabItem { Tabs.home.tabContent }.tag(Tabs.home)
            Text("Search").tabItem { Tabs.search.tabContent }.tag(Tabs.search)
            Text("Trends").tabItem { Tabs.trends.tabContent }.tag(Tabs.trends)
            Text("Settings").tabItem { Tabs.settings.tabContent }.tag(Tabs.settings)
        }
    }
}

#Preview {
    ContentView()
}
