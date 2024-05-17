//
//  Spending_TrackerApp.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

@main
struct Spending_TrackerApp: App {
    var themeHandler = ThemeHandler()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeHandler)
        }
        .modelContainer(for: [Transactions.self])
    }
}
