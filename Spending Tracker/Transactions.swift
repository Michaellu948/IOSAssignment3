//
//  Transactions.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI
import SwiftData

@Model
class Transactions{
    var color: Color = .red
    var title: String
    var description: String
    var amount: Double
    var dateAdded: Date
    var classification: String
    var assignColour: String

    
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


