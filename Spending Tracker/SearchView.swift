//
//  SearchView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI
import Combine

struct SearchView: View {
    @State private var searchTxt: String = ""
    @State private var filterTxt: String = ""
    @State private var selectedclassification: Classification? = nil
    @State private var isEditingTransaction = false
    @State private var transactionToEdit: Transactions?
    
    let searchPublisher = PassthroughSubject<String, Never>()
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVStack(spacing: 12){
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
                    EmptyView()
                }
            )
            .onChange(of: searchTxt, {oldText, newText in
                if newText.isEmpty{
                    filterTxt = ""
                }
                searchPublisher.send(newText)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: {text in filterTxt = text
            })
            .searchable(text: $searchTxt)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    ToolBarContent()
                }
            }
        }
    }
    
    @ViewBuilder
    func ToolBarContent() -> some View{
        Menu{
            Button{
                selectedclassification = nil
            }label: {
                HStack{
                    Text("Both")
                    
                    if selectedclassification == nil{
                        Image(systemName: "checkmark")
                    }
                }
            }
            ForEach(Classification.allCases, id: \.rawValue) { classification in
                Button{
                    selectedclassification = classification
                }label: {
                    HStack{
                        Text(classification.rawValue)
                        
                        if selectedclassification == classification{
                            Image(systemName: "checkmark")
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
