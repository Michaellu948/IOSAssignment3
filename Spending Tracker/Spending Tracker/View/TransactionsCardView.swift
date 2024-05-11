//
//  TransactionsCardView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct TransactionsCardView: View {
    @Environment(\.modelContext) private var context
    var transactions: Transactions
    var body: some View {
        HStack {
            // Leading icon with dynamic background based on transaction type
            Circle()
                .fill(transactions.colour.gradient)
                .frame(width: 45, height: 45)
                .overlay(
                    Text("\(String(transactions.remarks.prefix(1)))")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                )

            // Transaction details
            VStack(alignment: .leading, spacing: 6) {
                Text(transactions.remarks)
                    .font(.headline)
                    .lineLimit(1)

                Text(transactions.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Text(format(date: transactions.dateAdded, format: "dd MMM yyyy"))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)

            Spacer()

            // Amount display
            Text(currencyString(transactions.amount, allowedDigits: 2))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
