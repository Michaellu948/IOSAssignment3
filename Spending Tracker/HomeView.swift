//
//  HomeView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("userName") private var userName: String = ""
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var selectedCategory: Classification = .expense
    @Namespace private var animation
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing:10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("\(format(date: startDate, format: "dd - MMM yy")) to \(format(date: startDate, format: "dd - MMM yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            })
                            .hSpacing(.leading)
                            
                            CardView(income: 2038, expense: 4098)
                            
                            CustomSegmentedControl()
                            
                            ForEach(sampleTransactions) { transaction in
                                TransactionsCardView(transactions: transaction)
                            }
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))

            }
        }
    }
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            })
            .visualEffect { content, geometryProxy in
                content.scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            Spacer(minLength: 0)
            NavigationLink {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .background(.blue.gradient, in: .circle)
                    .contentShape(.circle)
            }

        }
        .padding(.bottom, userName.isEmpty ? 10 : 5)
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Divider()
                    .visualEffect { content, geometryProxy in
                        content
                            .opacity(headerBGOpacity(geometryProxy))
                    }
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
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "CURRENTTAB", in: animation)
                        }
                    }
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedCategory = classification
                        }
                    }
            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 5)
    }
    
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 15)
    }
    
    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.6
        return 1 + scale
    }
}

#Preview {
    ContentView()
}
