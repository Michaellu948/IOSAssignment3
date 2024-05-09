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
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    

    

}



#Preview {
    TrendsView()
}
