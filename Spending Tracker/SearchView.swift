//
//  SearchView.swift
//  Spending Tracker
//
//  Created by JohnTSS on 2/5/2024.
//

import SwiftUI
import Combine

// View for searching and filtering transactions in the Spending Tracker app.
struct SearchView: View {
    @State private var searchTxt: String = ""
    @State private var filterTxt: String = ""
    @State private var selectedClassification: Classification? = nil
    @State private var isEditingTransaction = false
    @State private var transactionToEdit: Transactions?
    
    // Publisher for debouncing search input
    private let searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack {
                    // Filtered list of transactions
                    FilterTransactionView(
                        classification: selectedClassification,
                        searchText: filterTxt,
                        content: transactionsList
                    )
                }
                .padding(15)
                .background(Color.gray.opacity(0.15))
                .background(navigationLink)
                .onChange(of: searchTxt, perform: handleSearchTextChange)
                .onReceive(
                    searchPublisher
                        .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main),
                    perform: { filterTxt = $0 }
                )
                .searchable(text: $searchTxt)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        ToolBarContent(selectedClassification: $selectedClassification)
                    }
                }
            }
        }
    }
    
    // Function to generate the list of transactions
    @ViewBuilder
    private func transactionsList(transactions: [Transactions]) -> some View {
        ForEach(transactions) { transaction in
            TransactionButton(
                transaction: transaction,
                isEditingTransaction: $isEditingTransaction,
                transactionToEdit: $transactionToEdit
            )
        }
    }
    
    // Navigation link to AddTransactionView when editing a transaction
    private var navigationLink: some View {
        NavigationLink(
            destination: AddTransactionView(editTransaction: transactionToEdit),
            isActive: $isEditingTransaction
        ) {
            EmptyView()
        }
    }
    
    // Handle changes in the search text
    private func handleSearchTextChange(_ newText: String) {
        filterTxt = newText.isEmpty ? "" : newText
        searchPublisher.send(newText)
    }
}

// Button view for each transaction in the list
private struct TransactionButton: View {
    let transaction: Transactions
    @Binding var isEditingTransaction: Bool
    @Binding var transactionToEdit: Transactions?
    
    var body: some View {
        Button(action: {
            transactionToEdit = transaction
            isEditingTransaction = true
        }) {
            TransactionsCardView(transactions: transaction)
        }
        .buttonStyle(.plain)
    }
}

// Toolbar for filtering transactions
private struct ToolBarContent: View {
    @Binding var selectedClassification: Classification?
    
    var body: some View {
        Menu {
            // Filter button for "Both" classifications
            filterButton(title: "Both", classification: nil)
            
            // Filter buttons for each classification (income / expense)
            ForEach(Classification.allCases, id: \.rawValue) { classification in
                filterButton(title: classification.rawValue, classification: classification)
            }
        } label: {
            Image(systemName: "slider.vertical.3")
        }
    }
    
    @ViewBuilder
    private func filterButton(title: String, classification: Classification?) -> some View {
        Button {
            selectedClassification = classification
        } label: {
            HStack {
                Text(title)
                if selectedClassification == classification {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
