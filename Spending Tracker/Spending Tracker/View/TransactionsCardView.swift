//
//  TransactionsCardView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

// card-like view for single transaction
struct TransactionsCardView: View {
    @Environment(\.modelContext) private var context
    var transactions: Transactions

    var body: some View {
        HStack {
            LeadingIconView(transactions: transactions)
            
            TransactionDetailsView(transactions: transactions)
                .padding(.leading, 10)
            
            Spacer()
            
            TransactionAmountView(amount: transactions.amount)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5) // Shadow for 3D effect
    }
}

// View for the leading icon with gradient color based on transaction type
struct LeadingIconView: View {
    var transactions: Transactions
    
    var body: some View {
        Circle()
            .fill(transactions.colour.gradient)
            .frame(width: 45, height: 45)
            .overlay(
                Text("\(String(transactions.remarks.prefix(1)))") // Displays the first letter of remarks
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            )
    }
}

// View for displaying transaction details
struct TransactionDetailsView: View {
    var transactions: Transactions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(transactions.remarks)
                .font(.headline)
                .lineLimit(1) // Limits the text to one line

            Text(transactions.title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1) // Limits the text to one line

            Text(format(date: transactions.dateAdded, format: "dd MMM yyyy")) // Formatted transaction date
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// View for displaying the transaction amount
struct TransactionAmountView: View {
    var amount: Double
    
    var body: some View {
        Text(currencyString(amount, allowedDigits: 2)) // Formats the amount as a currency string
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
}
