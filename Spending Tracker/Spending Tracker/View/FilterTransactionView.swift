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
    
    @Query(animation: .snappy) private var transactions: [Transactions]
    
    init(classification: Classification?, searchText: String?, showIncome: Bool = true, showExpense: Bool = true, @ViewBuilder content: @escaping ([Transactions]) -> Content) {
        let predicate = FilterTransactionView.createPredicate(classification: classification, searchText: searchText, showIncome: showIncome, showExpense: showExpense)
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\Transactions.dateAdded, order: .reverse)
        ], animation: .snappy)
        self.content = content
    }

    var body: some View {
        content(transactions)
    }
    
    private static func createPredicate(classification: Classification?, searchText: String?, showIncome: Bool, showExpense: Bool) -> Predicate<Transactions> {
        let rawValue = classification?.rawValue ?? ""
        
        if let searchText = searchText, !searchText.isEmpty {
            return #Predicate<Transactions> { transaction in
                (transaction.title.localizedStandardContains(searchText) ||
                 transaction.remarks.localizedStandardContains(searchText)) &&
                (rawValue.isEmpty ? true : transaction.classification == rawValue) &&
                ((showIncome && transaction.amount > 0) || (showExpense && transaction.amount < 0))
            }
        } else {
            return #Predicate<Transactions> { transaction in
                (rawValue.isEmpty ? true : transaction.classification == rawValue) &&
                ((showIncome && transaction.amount > 0) || (showExpense && transaction.amount < 0))
            }
        }
    }
}

