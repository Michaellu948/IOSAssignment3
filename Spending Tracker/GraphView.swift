//
//  SearchView.swift
//  Spending Tracker
//
//  Created by Donghyeop Lee on 9/5/2024.
//
import SwiftUI
import SwiftData


struct GraphView: View {
    @Query(animation: .snappy) private var transactions: [Transactions]

    private var expenseTransactions: [Transactions] {
        transactions.filter { $0.classification == Classification.expense.rawValue }
    }
    private var mostExpensiveTransaction: Transactions? {
                expenseTransactions.max(by: { $0.amount < $1.amount })
            }

    var body: some View {
        VStack {
            Text("Expenses Overview")
                .font(.title)
                .padding()
            
            GeometryReader { geometry in
                createPieChart(geometry: geometry)
                
                legendView()
                    .padding(.top, 20)
            }
            .frame(height: 480)
            .padding()
            
            if let mostExpensive = mostExpensiveTransaction {
                VStack {
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
    private func aggregateExpensesByTitle() -> [String: Double] {
        var aggregatedExpenses: [String: Double] = [:]
        for transaction in expenseTransactions {
            aggregatedExpenses[transaction.title, default: 0] += transaction.amount
        }
        return aggregatedExpenses
    }
    
    
    private func calculateAngles(for expenses: [String: Double], totalAmount: Double) -> [(title: String, color: Color, startAngle: CGFloat, endAngle: CGFloat)] {
        var slices: [(title: String, color: Color, startAngle: CGFloat, endAngle: CGFloat)] = []
        var startAngle = -CGFloat.pi / 2

        for (index, title) in expenses.keys.enumerated() {
            let amount = expenses[title] ?? 0
            let endAngle = startAngle + 2 * .pi * CGFloat(amount / totalAmount)
            slices.append((title, colorForIndex(index), startAngle, endAngle))
            startAngle = endAngle
        }

        return slices
    }


    
    private func createPieChart(geometry: GeometryProxy) -> some View {
        let width = min(geometry.size.width, geometry.size.height)
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = width / 3
        let expenses = aggregateExpensesByTitle()
        let totalAmount = expenses.values.reduce(0, +)
        let slices = calculateAngles(for: expenses, totalAmount: totalAmount)

        return ZStack {
            ForEach(slices, id: \.title) { slice in
                PieSliceView(color: slice.color, title: slice.title, startAngle: slice.startAngle, endAngle: slice.endAngle, center: center, radius: radius)
            }
        }
    }


    private func legendView() -> some View {
        VStack(alignment: .leading) {
            ForEach(Array(aggregateExpensesByTitle().keys.enumerated()), id: \.element) { index, title in
                LegendView(color: colorForIndex(index), text: title)
            }
        }
    }

    
    private func cumulativeAngles(for transactions: [Transactions], total: Double) -> [(start: CGFloat, end: CGFloat)] {
        var angles = [(start: CGFloat, end: CGFloat)]()
        var startAngle = -CGFloat.pi / 2
        
        for transaction in transactions {
            let endAngle = startAngle + 2 * .pi * CGFloat(transaction.amount / total)
            angles.append((start: startAngle, end: endAngle))
            startAngle = endAngle
        }
        
        return angles
    }
}

struct LegendView: View {
    var color: Color
    var text: String

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

private func colorForIndex(_ index: Int) -> Color {
    let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .gray, .pink, .cyan, .mint]
    return colors[index % colors.count]
}

struct PieSliceView: View {
    var color: Color
    var title: String
    var startAngle: CGFloat
    var endAngle: CGFloat
    var center: CGPoint
    var radius: CGFloat

    var body: some View {
        Path { path in
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: Angle(radians: Double(startAngle)), endAngle: Angle(radians: Double(endAngle)), clockwise: false)
        }
        .fill(color)
        .overlay(
            labelPositioned(startAngle: startAngle, endAngle: endAngle, label: title, center: center, radius: radius)
        )
    }

    private func labelPositioned(startAngle: CGFloat, endAngle: CGFloat, label: String, center: CGPoint, radius: CGFloat) -> some View {
        let midAngle = (startAngle + endAngle) / 2
        let x = center.x + radius * 0.75 * cos(midAngle)
        let y = center.y + radius * 0.75 * sin(midAngle)

        return Text(label)
            .position(x: x, y: y)
            .foregroundColor(.white)
    }


    private func colorForIndex(_ index: Int) -> Color {
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .gray, .pink, .cyan, .mint]
        return colors[index % colors.count]
    }

}

#Preview{
    GraphView()
    
}
