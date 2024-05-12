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
            VStack(spacing: 0) { // show balnace on screen
                Text("Current Balance:")
                .font(.title.bold())

                HStack(spacing: 12) {
                    Text("\(currencyString(income - expense))")
                        .font(.title.bold())
                }
                .padding(.bottom, 25)
                
                HStack(spacing: 0) {
                    ForEach(Classification.allCases, id: \.rawValue) { classification in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(classification.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                // show all epesnse or iincome
                                Text(currencyString(classification == .income ? income : expense, allowedDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue, in: RoundedRectangle(cornerRadius: 10))
                            }//
                            if classification == .income {
                                Spacer(minLength: 10)
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
        CardView(income: 1000, expense: 1000)
    }
}
