//
//  AssignColour.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct AssignColour: Identifiable {
    let id: UUID = .init()
    var colours: String
    var value: Color
}

// colour setting
var colours: [AssignColour] = [
    .init(colours: "Red", value: .red),
    .init(colours: "Orange", value: .orange),
    .init(colours: "Yellow", value: .yellow),
    .init(colours: "Green", value: .green),
    .init(colours: "Blue", value: .blue),
    .init(colours: "Indigo", value: .indigo),
    .init(colours: "Purple", value: .purple),
    .init(colours: "Pink", value: .pink)
]
