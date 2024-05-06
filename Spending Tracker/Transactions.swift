//
//  Transactions.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct Transactions: Identifiable {
    let id: UUID = .init()
    let color: Color = .red
    var title: String
    var classification: String
    var amount: Double
    var dateAdded: Date
    var assignColour: String
    var description: String
    
    init(title: String, description: String, amount: Double, dateAdded: Date, classification: Classification, assignColour: AssignColour) {
        self.title = title
        self.description = description
        self.classification = classification.rawValue
        self.amount = amount
        self.dateAdded = dateAdded
        self.assignColour = assignColour.colours
    }
    
    var colour: Color {
        return colours.first(where: {$0.colours == assignColour})?.value ?? color
    }
}

var sampleTransactions: [Transactions] = [
    .init(title: "Magic Keyboard", description: "Apple Product", amount: 129, dateAdded: .now, classification: .expense, assignColour: colours.randomElement()!),
    .init(title: "Apple Music", description: "Subscription", amount: 10.99, dateAdded: .now, classification: .expense, assignColour: colours.randomElement()!),
    .init(title: "iCloud+", description: "Subscription", amount: 0.99, dateAdded: .now, classification: .expense, assignColour: colours.randomElement()!),
    .init(title: "Payment", description: "Payment Recieved! ", amount: 2499, dateAdded: .now, classification: .income, assignColour: colours.randomElement()!)
]
