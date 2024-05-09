//
//  TransactionTypes.swift
//  Spending Tracker
//
//  Created by Michael Lu on 9/5/2024.
//

import SwiftUI

enum TransactionTypes: String {
    case food = "Food"
    case groceries = "Groceries"
    case transport = "Transport"
    case entertainment = "Entertainment"
    case other = "Others"
    
    @ViewBuilder
    var transactionType: some View {
        switch self {
        case .food:
            Image(systemName: "fork.knife")
            Text(self.rawValue)
        case .groceries:
            Image(systemName: "cart")
            Text(self.rawValue)
        case .transport:
            Image(systemName: "car")
            Text(self.rawValue)
        case .entertainment:
            Image(systemName: "movieclapper")
            Text(self.rawValue)
        case .other:
            Image(systemName: "doc.questionmark")
            Text(self.rawValue)

        }
    }
}
