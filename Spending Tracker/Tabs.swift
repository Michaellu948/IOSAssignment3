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
    case trends = "Trends"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .home:
            Image(systemName: "house")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .trends:
            Image(systemName: "chart.bar.xaxis")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }
}


