//
//  SearchView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI
import Combine

// View for searching and filtering transactions in the Spending Tracker app.
struct SearchView: View {
    @State private var searchTxt: String = ""
    @State private var filterTxt: String = ""
    @State private var selectedclassification: Classification? = nil
    @State private var isEditingTransaction = false // Boolean to control the display of the transaction edit view.
    @State private var transactionToEdit: Transactions? // Holds the transaction to be edited.
    
    let searchPublisher = PassthroughSubject<String, Never>() // Publisher for debouncing search input.
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVStack(spacing: 12){
                    // FilterTransactionView handles displaying filtered transactions.
                    FilterTransactionView(classification: selectedclassification, searchText: filterTxt) { transactions in
                        ForEach(transactions){transaction in
                            Button(action:{
                                transactionToEdit = transaction
                                isEditingTransaction = true
                            }) {
                                TransactionsCardView(transactions: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                }
                .padding(15)
            }
            .background(.gray.opacity(0.15))
            .background(
                NavigationLink(destination: AddTransactionView(editTransaction: transactionToEdit), isActive: $isEditingTransaction) {
                    EmptyView() // NavigationLink is used to open the transaction edit view.
                }
            )
            // React to changes in search text.
            .onChange(of: searchTxt, {oldText, newText in
                if newText.isEmpty{
                    filterTxt = ""
                }
                searchPublisher.send(newText)
            })
            // Setup debouncing for the search input.
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: {text in filterTxt = text // Update filter text after debounce interval.
            })
            .searchable(text: $searchTxt) // Enable search functionality
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    ToolBarContent() // Toolbar for filtering (income / expense)
                }
            }
        }
    }
    
    // View builder for the toolbar content, providing a menu to select filters.
    @ViewBuilder
    func ToolBarContent() -> some View{
        Menu{
            Button{
                selectedclassification = nil // Reset filter to show all transactions.
            }label: {
                HStack{
                    Text("Both")
                    
                    if selectedclassification == nil{
                        Image(systemName: "checkmark") // Show checkmark if no filter is selected.
                    }
                }
            }
            ForEach(Classification.allCases, id: \.rawValue) { classification in
                Button{
                    selectedclassification = classification // Set filter based on selected classification.
                }label: {
                    HStack{
                        Text(classification.rawValue)
                        
                        if selectedclassification == classification{
                            Image(systemName: "checkmark") // Show checkmark if this classification is selected.
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "slider.vertical.3")
        }
    }
}

#Preview {
    SearchView()
}
