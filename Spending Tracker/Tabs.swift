//
//  Tabs.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

enum Tabs: String {
    case home = "Home"
    case search = "Search"
    case graph = "Graph"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .home:
            Image(systemName: "house")
            Text(self.rawValue)
        case .search:
            Image(systemName: "doc.text.magnifyingglass")
            Text(self.rawValue)
        case .graph:
            Image(systemName: "chart.pie")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gear")
            Text(self.rawValue)
        }
    }
}


