//
//  AddTransactionView.swift
//  Spending Tracker
//
//  Created by JohnTSS on 7/5/2024.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var editTransaction: Transactions?
    
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var classification: Classification = .expense
    @State var assignColour: AssignColour = colours.randomElement()!
    
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 15){
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                TransactionsCardView(transactions: .init(title: title.isEmpty ? "Title" : title, remarks: remarks.isEmpty ? "Description" : remarks, amount: amount, dateAdded: dateAdded, classification: classification, assignColour: assignColour))
                
                CustomSection("Title", "Enter title here", value: $title)
                
                CustomSection("Description", "Enter description here", value: $remarks)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Amount and Classification")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                   
                    
                    HStack(spacing: 15){
                        TextField("0.0", value: $amount, formatter: numberFormatter)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(.background, in: .rect(cornerRadius: 10))
                            .frame(maxWidth: 150)
                        
                        ClassficationCheckBox()
                        
                    }
                })
                
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                }
                )}
            
            .padding()
        }
        .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction")
        .background(.gray.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing){
                Button("Save", action: saveTransaction)
            }
            ToolbarItem(placement: .bottomBar) {
                if editTransaction != nil {
                    Button("Delete", role: .destructive, action: deleteTransaction)
                }
            }
            
        })
        .onAppear(perform: {
            if let editTransaction{
                //Load all existing data from transaction
                title = editTransaction.title
                remarks = editTransaction.remarks
                dateAdded = editTransaction.dateAdded
                if let classification = editTransaction.newClassification{
                    self.classification = classification
                    
                }
                amount = editTransaction.amount
                if let assignColour = editTransaction.assignCol{
                    self.assignColour = assignColour
                }
            }
        })
    }
    
    func saveTransaction(){
        //Save transaction to SwiftData
        if editTransaction != nil{
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.classification = classification.rawValue
            editTransaction?.dateAdded = dateAdded
            
        } else{
            let transaction = Transactions(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, classification: classification, assignColour: assignColour)
            context.insert(transaction)
        }
        dismiss()
    }
    
    func deleteTransaction() {
        if let editTransaction = editTransaction {
            context.delete(editTransaction)
            dismiss()
        }
    }
    
    @ViewBuilder
    func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View{
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            
            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(.background, in: .rect(cornerRadius: 10))
        })
    }
    
    @ViewBuilder
    func ClassficationCheckBox() -> some View{
        HStack(spacing: 10){
            ForEach(Classification.allCases, id: \.rawValue){ classification in
                HStack(spacing: 5){
                    ZStack{
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(.blue)
                        
                        if self.classification == classification{
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    Text(classification.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture{
                    self.classification = classification
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    
    var numberFormatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
}

#Preview {
    NavigationStack{
        AddTransactionView()
    }
}
