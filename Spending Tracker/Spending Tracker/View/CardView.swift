//
//  CardView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct CardView: View {
    var income: Double
    var expense: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
            
            VStack(spacing: 0) {
                BalanceView(balance: income - expense)
                .padding(.bottom, 25)
                
                ClassificationView(income: income, expense: expense)
            }
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 15)
        }
    }
}

// Display current balance
struct BalanceView: View {
    var balance: Double

    var body: some View {
        VStack {
            Text("Current Balance:")
                .font(.title.bold())

            HStack(spacing: 12) {
                Text("\(currencyString(balance))")
                    .font(.title.bold())
            }
        }
    }
}

// display income and expense classifications
struct ClassificationView: View {
    var income: Double
    var expense: Double

    var body: some View {
        HStack(spacing: 0) {
            // Loop through each classification (income and expense)
            ForEach(Classification.allCases, id: \.rawValue) { classification in
                // Classification item view for each classification
                ClassificationItemView(classification: classification, amount: classification == .income ? income : expense)
                
                if classification == .income {
                    Spacer(minLength: 10)
                }
            }
        }
    }
}

// display a single classification item (income or expense)
struct ClassificationItemView: View {
    var classification: Classification
    var amount: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(classification.rawValue)
                .font(.caption2)
                .foregroundStyle(.gray)
            
            Text(currencyString(amount, allowedDigits: 0))
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 0, expense: 7)
    }
}
