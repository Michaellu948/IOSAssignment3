//
//  SettingsView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeHandler: ThemeHandler // Access to the theme handler which manages dark mode settings.
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $themeHandler.isDarkModeEnabled) { // Toggle switch for dark mode
                        Text("Dark Mode")
                    }
                }
                .navigationTitle("Settings")
            }
            .preferredColorScheme(themeHandler.isDarkModeEnabled ? .dark : .light) // Dynamically sets the color scheme based on the dark mode setting.
        }
    }
}

#Preview {
    SettingsView()
}
