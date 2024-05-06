//
//  Transactions.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct Transactions: Identifiable {
    let id: UUID = .init()
    var title: String
    var classification: String
    var amount: Double
    var dataAdded: Date
    var assignColour: String
    
    init(title: String, classification: Classification, amount: Double, dataAdded: Date, assignColour: AssignColour) {
        self.title = title
        self.classification = classification.rawValue
        self.amount = amount
        self.dataAdded = dataAdded
        self.assignColour = assignColour.colours
    }
    
    var colour: Color {
        return colours.first(where: {$0.colours == assignColour})?.value ?? appColour
    }
}

