//
//  HomeView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 2/5/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var selectedClassification: Classification = .expense
    // Query to sort transactions by date added in descending order
    @Query(sort: [SortDescriptor(\Transactions.dateAdded, order: .reverse)]) private var transactions: [Transactions]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    // Section to display totals and filtered transactions
                    transactionsSection
                }
                .padding(10)
            }
            .background(Color.gray.opacity(0.15))
            .navigationDestination(for: Transactions.self) { transaction in
                // Navigate to AddTransactionView when a transaction is selected
                AddTransactionView(editTransaction: transaction)
            }
        }
    }
    
    // Section view containing totals, classification picker, and transactions list
    private var transactionsSection: some View {
        Section {
            // View to display total income and expense
            TotalsCardView(transactions: transactions)
            
            // Picker to select between income and expense
            ClassificationPicker(selectedClassification: $selectedClassification)
                .padding(.bottom, 10)
            
            // List of transactions filtered by selected classification
            TransactionsList(transactions: transactions, selectedClassification: $selectedClassification)
        } header: {
            // Header view with welcome message and add transaction button
            HeaderView()
        }
    }
}

// View to display total income and expense in a card
private struct TotalsCardView: View {
    let transactions: [Transactions]
    
    var body: some View {
        CardView(income: total(transactions, classification: .income),
                 expense: total(transactions, classification: .expense))
    }
}

// Picker view to select between income and expense classifications
private struct ClassificationPicker: View {
    @Binding var selectedClassification: Classification
    
    var body: some View {
        Picker("Classification", selection: $selectedClassification) {
            ForEach(Classification.allCases, id: \.self) { classification in
                Text(classification.rawValue)
                    .tag(classification)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.top, 5)
    }
}

// List of transactions filtered by the selected classification
private struct TransactionsList: View {
    let transactions: [Transactions]
    @Binding var selectedClassification: Classification
    
    var body: some View {
        ForEach(transactions.filter { $0.classification == selectedClassification.rawValue }) { transaction in
            NavigationLink(value: transaction) {
                TransactionsCardView(transactions: transaction)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome!")
                    .font(.title.bold())
            }
            Spacer()
            NavigationLink {
                AddTransactionView()
            } label: {
                Text("Add Transaction")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(width: 150, height: 40)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            }
        }
        .background {
            VStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
            .padding(.horizontal, -10)
        }
    }
}

#Preview {
    ContentView()
}
