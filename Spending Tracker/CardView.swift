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
                .fill(.background)
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("\(currencyString(income - expense))")
                        .font(.title.bold())
                    
                    Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundStyle(expense > income ? .red : .green)
                }
                .padding(.bottom, 25)
                
                HStack(spacing: 0) {
                    ForEach(Classification.allCases, id: \.rawValue) { classification in
                        let symbolImage = classification == .income ? "arrow.down" : "arrow.up"
                        let tint = classification == .income ? Color.green : Color.red
                        HStack(spacing: 10) {
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundColor(tint)
                                .frame(width: 35, height: 35)
                                .background {
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(classification.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                Text(currencyString(classification == .income ? income : expense, allowedDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                            }
                            
                            if classification == .income {
                                Spacer(minLength: 10)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 15)
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 4590, expense: 2389)
    }
}
