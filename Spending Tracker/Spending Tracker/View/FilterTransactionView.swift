//
//  FilterTransactionView.swift
//  Spending Tracker
//
//  Created by Donghyeop Lee on 5/9/24.
//

import SwiftUI
import SwiftData

struct FilterTransactionView<Content: View>: View {
    var content: ([Transactions]) -> Content
    
    @Query(animation: .snappy) private var transactions: [Transactions]
    
    init(classification: Classification?, searchText: String?, showIncome: Bool = true, showExpense: Bool = true, @ViewBuilder content: @escaping ([Transactions]) -> Content) {
        // check search text is same as expense item and income item
        var predicate: Predicate<Transactions>
        let rawValue = classification?.rawValue ?? ""
        // check search text is include title and remarks
        if let searchText = searchText, !searchText.isEmpty {
            predicate = #Predicate<Transactions> {transaction in
                //if its not empty will show the values has that word
                return (transaction.title.localizedStandardContains(searchText) ||
                        transaction.remarks.localizedStandardContains(searchText)) &&
                    (rawValue.isEmpty ? true : transaction.classification == rawValue) &&
                    ((showIncome && transaction.amount > 0) || (showExpense && transaction.amount < 0))
            }
        } else {
            predicate = #Predicate<Transactions> {transaction in // just show 
                return (rawValue.isEmpty ? true : transaction.classification == rawValue) &&
                    ((showIncome && transaction.amount > 0) || (showExpense && transaction.amount < 0))
            }
        }
        _transactions = Query(filter: predicate, sort:[
            SortDescriptor(\Transactions.dateAdded, order: .reverse)
        ], animation: .snappy)
        self.content = content
    }

    var body: some View {
        content(transactions)
    }
    
}


