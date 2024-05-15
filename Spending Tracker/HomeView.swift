//
//  HomeView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var selectedClassification: Classification = .expense
    @Query(sort: [SortDescriptor(\Transactions.dateAdded, order: .reverse)]) private var transactions: [Transactions]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    transactionsSection
                }
                .padding(10)
            }
            .background(Color.gray.opacity(0.15))
            .navigationDestination(for: Transactions.self) { transaction in
                AddTransactionView(editTransaction: transaction)
            }
        }
    }
    
    private var transactionsSection: some View {
        Section {
            TotalsCardView(transactions: transactions)
            
            ClassificationPicker(selectedClassification: $selectedClassification)
                .padding(.bottom, 10)
            
            TransactionsList(transactions: transactions, selectedClassification: $selectedClassification)
        } header: {
            HeaderView()
        }
    }
}

private struct TotalsCardView: View {
    let transactions: [Transactions]
    
    var body: some View {
        CardView(income: total(transactions, classification: .income),
                 expense: total(transactions, classification: .expense))
    }
}

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
