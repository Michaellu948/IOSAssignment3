import SwiftUI

struct TrendsView: View {
    @Query(animation: .snappy) private var transactions: [Transactions]

    // This part calculates the total of all transactions for proper pie slice calculations
    private var total: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    private func angleMultiplier(_ transaction: Transactions) -> Double {
        transaction.amount / total
    }

    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: width / 2, y: width / 2)
            let radius = width / 2
            var startAngle = -CGFloat.pi / 2  // Start from the top of the circle

            ZStack {
                ForEach(transactions, id: \.id) { transaction in
                    Path { path in
                        let endAngle = startAngle + 2 * .pi * CGFloat(angleMultiplier(transaction))
                        path.move(to: center)
                        path.addArc(center: center, radius: radius, startAngle: Angle(radians: Double(startAngle)), endAngle: Angle(radians: Double(endAngle)), clockwise: false)
                        startAngle = endAngle
                    }
                    .fill(self.colorForTransaction(transaction))  // You would need to define this method to choose colors
                }
            }
        }
        .frame(height: 300)  // Fixed height for the pie chart
        .padding()
    }

    // Example method to choose colors for each transaction
    private func colorForTransaction(_ transaction: Transactions) -> Color {
        // This is a simple way to assign a color based on the transaction's title hash.
        // In a real application, you might use a more sophisticated method.
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow]
        re
