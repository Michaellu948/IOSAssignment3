//
//  Classification.swift
//  Spending Tracker
//
//  Created by Donghyeop Lee on 8/5/2024.
//


import SwiftUI
import Charts
import SwiftData

struct GraphsViews : View{
    @Query(animation: .snappy) private var transactions: [Transactions]
    @State private var chartModel: [ChartModel] = []
    var body: some View{
        ScrollView(.vertical){
            LazyVStack(spacing: 10){

                .chartScrollableAxes(.horizontal) 
                .chartXVisibleDomain(length: 4)
                .chartLegend(position: .bottom, alignment: .trailing)
                .chartYAxis{
                    AxisMarks(position: .leading){ value in
                        let doubleValue = value.as(Double.self) ?? 0
                        
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel{
                            Text(axisLabel(doubleValue))
                        } 
                    }
                }

                .chartForegroundStlyeScale(range: [Color.green.gradient, Color.red.gradient ])


            }
            .onAppear  {
                task.detached(priority: .high){
                    let calander = Calendar.current

                    let groundByDate = Dictionary(grouping: transactions) { transaction in
                        let components = calander.DateComponents([.month, .year], from: transaction.dateAdded)

                        return components
                    }

                    let sortedGroups = groupedByDate.sorted{
                        let date1 = calander.date{from: $0.key} ?? .init()       
                        let date2 = calander.date{from: $1.key} ?? .init()       

                        return calander.compare(date1, to: date2, toGranularity: .day) == .orderedDecending
                    }

                    let charts = sortedGroups.compactMap { dict -> Charts? in
                        let date = calander.date(from: dict.key)
                        let income = dict.value.filter({ $0.classification == Classification.income.rawValue})
                        let expense = dict.value.filter({ $0.classification == Classification.expense.rawValue})

                        let incomeTotalValue = total(income, Classification: .income)
                        let expenseTotalValue = total(expense, Classification: .expense)

                        return .init{
                            date: date,
                            classifications: [
                                .init(totalValue: incomeTotalValue, Classification:.income)
                                .init(totalValue: expenseTotalValue, Classification:.expense)
                            ],
                            totalIncome: incomeTotalValue,
                            totalExpense: expenseTotalValue
                        }
                    } 

                }

            }
            func axisLabel( value: Double) -> String {
                let intValue = int(value)
                let kValue = int(value / 1000)    
                return intValue < 1000 ? "\(kValue)K" : "\(kValue)K"
            }

        }   
    }
    @viewBuilder
    func ChartView() -> some View{
        
        Charts{
            forEach(CategoryForChart) { group in
                forEach(group.classification) { chart
                    barMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.classification.rawValue, chart.totalValue),
                        width: 20
                    )
                
                        
                    .position(by: .value("classification", chart.classification.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("classification", chart.classification.rawValue) )

                }
            }
                    
        }   
    }
}


#Preview{
    GraphsViews()
}







