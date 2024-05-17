//
//  GraphView.swift
//  Spending Tracker
//
//  Created by Donghyeop Lee on 9/5/2024.
//
import SwiftUI
import SwiftData

struct GraphView: View {
    @Query(animation: .snappy) private var transactions: [Transactions]

    private var expenseTransactions: [Transactions] {
        // check only expense values
        transactions.filter {$0.classification == Classification.expense.rawValue}
    }
    
    private var mostExpensiveTransaction: Transactions? {
        // check the highest value
        expenseTransactions.max(by: {$0.amount < $1.amount})
    }
    
    // set category colour
    private let categoryColors: [String: Color] = [
        "Food": .red,
        "Groceries": .green,
        "Transport": .blue,
        "Entertainment": .orange,
        "Others": .gray
    ]
    
    var body: some View {
        VStack {
            Text("Expenses Overview")
                .font(.title)
                .padding()
            
            GeometryReader {geometry in
                createPieChart(geometry: geometry)
                legendView()
                    .padding(.top, 20)
            }
            .frame(height: 480)
            .padding()
            // set highest value
            if let mostExpensive = mostExpensiveTransaction {
                VStack { // show highest expense on screen
                    Text("Your highest expense is on ")
                    + Text("\(mostExpensive.title)")
                        .bold()
                        .foregroundColor(.red)
                    + Text(". Try to manage this category better next time.")
                }
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            }
        }
    }
    
    private func createPieChart(geometry: GeometryProxy) -> some View {
        // make pie chart with category
        let width = min(geometry.size.width, geometry.size.height)
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = width / 3
        let expenses = aggregateExpensesByTitle()
        let totalAmount = expenses.values.reduce(0, +)

        return ZStack {
            ForEach(Array(expenses.keys.enumerated()), id: \.element) {index, title in
                //following colour from category selected one
                if let color = categoryColors[title], let amount = expenses[title] {
                    let startAngle = index == 0 ? -CGFloat.pi / 2 : cumulativeAngles(for: expenses, totalAmount: totalAmount)[index - 1].end
                    let endAngle = startAngle + 2 * .pi * CGFloat(amount / totalAmount)
                    PieSliceView(color: color, title: title, startAngle: startAngle, endAngle: endAngle, center: center, radius: radius)
                }
            }
        }
    }

    private func legendView() -> some View {
        // legend view
        VStack(alignment: .leading) {
            ForEach(Array(categoryColors.keys.sorted()), id: \.self) {title in
                if let color = categoryColors[title] {
                    LegendView(color: color, text: title)
                }
            }
        }
    }
    
    private func aggregateExpensesByTitle() -> [String: Double] {
        //add all expenses on same category
        var aggregatedExpenses: [String: Double] = [:]
        for transaction in expenseTransactions {
            let title = transaction.title
            aggregatedExpenses[title, default: 0] += transaction.amount
        }
        return aggregatedExpenses
    }

    private func cumulativeAngles(for expenses: [String: Double], totalAmount: Double) -> [(start: CGFloat, end: CGFloat)] {
        //check angles
        var angles = [(start: CGFloat, end: CGFloat)]()
        var startAngle = -CGFloat.pi / 2 //angle start part
        for (index, _) in expenses.keys.enumerated() {
            let amount = expenses[Array(expenses.keys)[index]] ?? 0
            let endAngle = startAngle + 2 * .pi * CGFloat(amount / totalAmount)
            angles.append((start: startAngle, end: endAngle))
            startAngle = endAngle
        }
        return angles
    }
}

struct LegendView: View {
    var color: Color
    var text: String
    // show colour and what category it is
    var body: some View {
        HStack {
            Rectangle()
                .fill(color)
                .frame(width: 20, height: 20)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 1)
                )
            Text(text)
                .font(.caption)
        }
    }
}

struct PieSliceView: View {
    var color: Color
    var title: String
    var startAngle: CGFloat
    var endAngle: CGFloat
    var center: CGPoint
    var radius: CGFloat

    var body: some View {
        Path {path in
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: Angle(radians: Double(startAngle)), endAngle: Angle(radians: Double(endAngle)), clockwise: false)
        }
        .fill(color)
    }
}

#Preview{
    GraphView()
}
