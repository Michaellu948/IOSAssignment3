//
//  FilterTransactionView.swift
//  Spending Tracker
//
//  Created by 吴泓昕 on 5/9/24.
//

import SwiftUI
import SwiftData

struct FilterTransactionView<Content:View>: View {
    var content: ([Transactions]) -> Content
    
    @Query(animation: .snappy) private var transactions: [Transactions]
    init(classification: Classification?, searchText: String, @ViewBuilder content: @escaping ([Transactions]) -> Content) {

        let rawValue = classification?.rawValue ?? ""
        let predicate = #Predicate<Transactions> { transaction in
            return (transaction.title.localizedStandardContains(searchText) ||
                    transaction.remarks.localizedStandardContains(searchText)) && (rawValue.isEmpty ? true: transaction.classification == rawValue )
        }
        
        _transactions = Query(filter: predicate, sort:[
            SortDescriptor(\Transactions.dateAdded, order: .reverse)
        ], animation: .snappy)
        
        self.content = content
        
    }
    init(startDate: Date, endDate: Date, @ViewBuilder content: @escaping ([Transactions]) -> Content) {
        
        
        let predicate = #Predicate<Transactions> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
        }
        
        _transactions = Query(filter: predicate, sort:[
            SortDescriptor(\Transactions.dateAdded, order: .reverse)
        ], animation: .snappy)
        
        self.content = content
        
    }
    
    init(startDate: Date, endDate: Date, classification: Classification?,  @ViewBuilder content: @escaping ([Transactions]) -> Content) {

        let rawValue = classification?.rawValue ?? ""
        let predicate = #Predicate<Transactions> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate && (rawValue.isEmpty ? true: transaction.classification == rawValue )
        }
        
        _transactions = Query(filter: predicate, sort:[
            SortDescriptor(\Transactions.dateAdded, order: .reverse)
        ], animation: .snappy)
        
        self.content = content
        
    }
    var body: some View{
        content(transactions)
    }
    
}


