//
//  SearchView.swift
//  Spending Tracker
//
//  Created by Michael Lu on 6/5/2024.
//

import SwiftUI
import Combine

struct SearchView: View {
    @State private var searchTxt: String = ""
    @State private var filterTxt: String = ""
    let searchPublisher = PassthroughSubject<String, Never>()
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVStack(spacing: 12){
                }
            }
            .overlay(content: {
                ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                    .opacity(searchTxt.isEmpty ? 1 : 0)
            })
            .onChange(of: searchTxt, {oldText, newText in
                if newText.isEmpty{
                    filterTxt = ""
                }
                searchPublisher.send(newText)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in filterTxt = text
            })
            .searchable(text: $searchTxt)
            .navigationTitle("Search")
        }
    }
}

#Preview {
    SearchView()
}
