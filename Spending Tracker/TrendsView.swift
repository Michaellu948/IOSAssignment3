//
//  TrendsView.swift
//  Spending Tracker
//
//  Created by Donghyeop Lee on 8/5/2024.
//

import SwiftUI
import Charts
import SwiftData

struct TrendsView: View {
    @Query(animation: .snappy) private var transactions: [Transactions]
    @State private var chartData: [ChartModel] = []
    
         var body: some View {
        PieChart {
            ForEach(transactions) { transaction in
                PieChartSlice(value: transactions.amount, label: Text(transactions.title), legend: Text(transactions.title))
            }
        }
        .frame(height: 300)
        .padding()
    }
    

    

}



#Preview {
    TrendsView()
}

