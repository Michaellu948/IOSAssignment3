//
//  SettingsView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeHandler: ThemeHandler
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $themeHandler.isDarkModeEnabled) {
                        Text("Dark Mode")
                    }
                }
                .navigationTitle("Settings")
            }
            .preferredColorScheme(themeHandler.isDarkModeEnabled ? .dark : .light)
        }
    }
}

#Preview {
    SettingsView()
}
