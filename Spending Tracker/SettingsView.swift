//
//  SettingsView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = ""
    
    var body: some View {
        NavigationStack{
            List{
                Section("Username"){
                    TextField("Enter your username", text: $userName)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
