//
//  HomeView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var selectedCategory: Classification = .expense
    @Namespace private var animation
    
    // Query to sort transactions by date made
    @Query(sort: [SortDescriptor(\Transactions.dateAdded, order: .reverse)], animation: .snappy) private var transactions: [Transactions]
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing:10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            // Displays total income/expense
                            CardView(income: total(transactions, classification: .income),
                                     expense: total(transactions, classification: .expense))
                            
                            CustomSegmentedControl()
                                .padding(.bottom, 10)
                            
                            // Display individual transactions based on if its income or expense
                            ForEach(transactions.filter({ $0.classification == selectedCategory.rawValue})) { transaction in
                                NavigationLink(value: transaction){
                                    TransactionsCardView(transactions: transaction)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    header: {
                        HeaderView(size)
                    }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .navigationDestination(for: Transactions.self) { transaction in
                    AddTransactionView(editTransaction : transaction)
                }
                
            }
        }
    }
    
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Welcome!")
                    .font(.title.bold())
            })
            Spacer(minLength: 0)
            NavigationLink {
                AddTransactionView()
            } label: {
                Text("Add Transaction")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 45)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
        }
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Divider()
            }
            .padding(.horizontal, -15)
            .padding(.top, -(safeArea.top + 15))
        }
    }
    
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach(Classification.allCases, id: \.rawValue) { classification in
                Text(classification.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if classification == selectedCategory {
                            Rectangle()
                                .fill(.background)
                                .matchedGeometryEffect(id: "CURRENTTAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            selectedCategory = classification
                        }
                    }
            }
        }
        .background(.gray.opacity(0.15), in: Rectangle())
        .padding(.top, 5)
    }
}

#Preview {
    ContentView()
}
