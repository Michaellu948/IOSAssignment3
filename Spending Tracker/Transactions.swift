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
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var classification: String
    var assignColour: String

    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, classification: Classification, assignColour: AssignColour) {
        self.title = title
        self.remarks = remarks
        self.classification = classification.rawValue
        self.amount = amount
        self.dateAdded = dateAdded
        self.assignColour = assignColour.colours
    }
    
    var colour: Color {
        return colours.first(where: {$0.colours == assignColour})?.value ?? appTint
    }
}


