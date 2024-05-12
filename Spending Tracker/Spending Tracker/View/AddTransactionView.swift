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

    @State private var selectedType: TransactionTypes = .food
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var classification: Classification = .expense
    @State var assignColour: AssignColour = colours.randomElement()!

    var body: some View {
        NavigationView {
            Form {
                // Add Transaction Card Preview Section
                Section(header: Text("Preview")) {
                    TransactionsCardView(transactions: .init(title: title, remarks: remarks.isEmpty ? "" : remarks, amount: amount, dateAdded: dateAdded, classification: classification, assignColour: assignColour))
                }
                Section(header: Text("Transaction Details").foregroundColor(.secondary)) {
                    Picker("Category", selection: $selectedType) {
                        ForEach(TransactionTypes.allCases, id: \.self) { type in
                            HStack{
                                type.transactionIcon
                                Text(type.rawValue)
                            }.tag(type)
                        }
                    }
                    .pickerStyle(.automatic)
                    .onChange(of: selectedType) {newValue in
                        title = newValue.rawValue
                    }
                    TextField("Description", text: $remarks)
                    
                    HStack {
                        Text("$").foregroundColor(.secondary)
                        TextField("Amount", value: $amount, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                    }
                    DatePicker("Date", selection: $dateAdded, displayedComponents: .date)
                }
                Section {
                    ClassificationPicker(classification: $classification)
                }
                Section {
                    Button("Save", action: saveTransaction)
                    if editTransaction != nil {
                        Button("Delete", role: .destructive, action: deleteTransaction)
                    }
                }
            }
            .navigationBarTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear(perform: loadTransaction)
    }

    func loadTransaction() {
        if let editTransaction = editTransaction {
            // Load existing data
            selectedType = TransactionTypes(rawValue: editTransaction.title) ?? .food
            title = editTransaction.title
            remarks = editTransaction.remarks
            amount = editTransaction.amount
            dateAdded = editTransaction.dateAdded
            classification = editTransaction.newClassification ?? .expense
            assignColour = editTransaction.assignCol ?? colours.randomElement()!
        } else {
            title = selectedType.rawValue
        }
    }
    
    func saveTransaction() {
        //Save transaction to SwiftData
        if let editTransaction = editTransaction {
            editTransaction.title = title
            editTransaction.remarks = remarks
            editTransaction.amount = amount
            editTransaction.classification = classification.rawValue
            editTransaction.dateAdded = dateAdded
        } else {
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
    func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View {
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
    func ClassficationCheckBox() -> some View {
        HStack(spacing: 10){
            ForEach(Classification.allCases, id: \.rawValue) {classification in
                HStack(spacing: 5){
                    ZStack{
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(.blue)
                        
                        if self.classification == classification {
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
    
    struct ClassificationPicker: View {
        @Binding var classification: Classification

        var body: some View {
            Picker("Classification", selection: $classification) {
                ForEach(Classification.allCases, id: \.self) {classification in
                    Text(classification.rawValue).tag(classification)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
}

extension TransactionTypes {
    @ViewBuilder
    var transactionIcon: some View {
        switch self {
        case .food:
            Image(systemName: "fork.knife")
        case .groceries:
            Image(systemName: "cart")
        case .transport:
            Image(systemName: "car")
        case .entertainment:
            Image(systemName: "movieclapper")
        case .salary:
            Image(systemName: "dollarsign.square.fill")
        case .other:
            Image(systemName: "doc.questionmark")
        }
    }
}

#Preview {
    NavigationStack{
        AddTransactionView()
    }
}
