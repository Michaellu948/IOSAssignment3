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
    // Query to sort transactions by date made
    @Query(sort: [SortDescriptor(\Transactions.dateAdded, order: .reverse)]) private var transactions: [Transactions]
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section {
                            // Displays total income/expense
                            CardView(income: total(transactions, classification: .income),
                                     expense: total(transactions, classification: .expense))
                            
                            CustomSegmentedControl()
                                .padding(.bottom, 10)
                            
                            // Display individual transactions based on if its income or expense
                            ForEach(transactions.filter({$0.classification == selectedClassification.rawValue})) {transaction in
                                NavigationLink(value: transaction) {
                                    TransactionsCardView(transactions: transaction)
                                }
                                .buttonStyle(.plain)
                            }
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(10)
                }
                .background(.gray.opacity(0.15))
                .navigationDestination(for: Transactions.self) {transaction in
                    AddTransactionView(editTransaction: transaction)
                }
            }
        }
    }
    
    // Header view that contains a welcome message and an add transaction button
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack() {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Welcome!")
                    .font(.title.bold())
            })
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
            VStack() {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .padding(.top, -(safeArea.top + 10))
            .padding(.horizontal, -10)
        }
    }
    
    // Creates a segmented control for filtering transactions by income/expense
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        Picker("Classification", selection: $selectedClassification) {
            ForEach(Classification.allCases, id: \.self) {classification in
                Text(classification.rawValue)
                    .tag(classification)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.top, 5)
    }
}

#Preview {
    ContentView()
}
