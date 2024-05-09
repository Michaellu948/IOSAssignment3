//
//  ChartModel.swift
//  Spending Tracker
//
//  Created by Donghyeop Lee on 8/5/2024.
//

import Foundation
import SwiftUI

struct ChartModel : Identifiable{
    let id: UUID = .init()
    var date: Date
    var classifications: [CategoryForChart]
    var totalIncome: Double
    var totalExpense: Double
}

struct CategoryForChart : Identifiable{
    let id: UUID = .init()
    var classification: Classification
    var totalValue: Double

}
