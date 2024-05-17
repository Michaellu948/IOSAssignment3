//
//  FilterTransactionView.swift
//  Spending Tracker
//
//  Created by JohnTSS on 6/5/24.
//

import SwiftUI
import SwiftData

struct FilterTransactionView<Content: View>: View {
    var content: ([Transactions]) -> Content
    
    // Query to fetch and filter transactions with animation
    @Query(animation: .snappy) private var transactions: [Transactions]
    
    // Initializer to set up filtering criteria and content view
    init(classification: Classification?, searchText: String?, showIncome: Bool = true, showExpense: Bool = true, @ViewBuilder content: @escaping ([Transactions]) -> Content) {
        // Create a predicate for filtering transactions based on given criteria
        let predicate = FilterTransactionView.createPredicate(classification: classification, searchText: searchText, showIncome: showIncome, showExpense: showExpense)
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\Transactions.dateAdded, order: .reverse)
        ], animation: .snappy)
        self.content = content
    }

    var body: some View {
        content(transactions)
    }
    
    // Static function to create a predicate for filtering transactions
    private static func createPredicate(classification: Classification?, searchText: String?, showIncome: Bool, showExpense: Bool) -> Predicate<Transactions> {
        let rawValue = classification?.rawValue ?? ""
        
        // If search text is provided and not empty, include it in the predicate
        if let searchText = searchText, !searchText.isEmpty {
            return #Predicate<Transactions> { transaction in
                // Filter transactions by title or remarks containing the search text,
                // by classification, and by income/expense status
                (transaction.title.localizedStandardContains(searchText) ||
                 transaction.remarks.localizedStandardContains(searchText)) &&
                (rawValue.isEmpty ? true : transaction.classification == rawValue) &&
                ((showIncome && transaction.amount > 0) || (showExpense && transaction.amount < 0))
            }
        } else {
            // Filter transactions by classification and by income/expense status
            return #Predicate<Transactions> { transaction in
                (rawValue.isEmpty ? true : transaction.classification == rawValue) &&
                ((showIncome && transaction.amount > 0) || (showExpense && transaction.amount < 0))
            }
        }
    }
}

