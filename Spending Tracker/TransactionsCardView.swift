//
//  TransactionsCardView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct TransactionsCardView: View {
    var transactions: Transactions
    var body: some View {
        HStack(spacing: 12) {
            Text("\(String(transactions.title.prefix(1)))")
                .font(.title)
                .fontWeight(.semibold)
                .frame(width:45, height: 45)
                .foregroundStyle(.white)
                .background(transactions.color.gradient, in: .circle)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(transactions.title)
                    .foregroundStyle(Color.primary)
                
                Text(transactions.description)
                    .font(.caption)
                    .foregroundStyle(Color.primary.secondary)
                
                Text(format(date: transactions.dateAdded, format: "dd - MMM yyyy"))
                    .font(.caption2)
                    .foregroundStyle(.gray)
            })
            .lineLimit(1)
            .hSpacing(.leading)
            
            Text(currencyString(transactions.amount, allowedDigits: 2))
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.background, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    TransactionsCardView(transactions: sampleTransactions[0])
}
