//
//  AddTransactionView.swift
//  Spending Tracker
//
//  Created by JohnTSS on 7/5/2024.
//
import SwiftUI

struct AddTransactionView: View {
    @Environment(\.modelContext) private var context // Access to the CoreData managed object context.
    @Environment(\.dismiss) private var dismiss // Dismissal handler for closing the view.
    var editTransaction: Transactions?
    
    @State private var selectedType: TransactionTypes = .food
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var classification: Classification = .expense
    @State private var assignColour: AssignColour = colours.randomElement()!
    
    var body: some View {
        NavigationView {
            Form {
                // Section to display a preview of the transaction card
                previewSection
                // Section for entering transaction details
                transactionDetailsSection
                // Section for selecting classification (Income / Expense)
                classificationPickerSection
                // Section for Save and Delete buttons
                actionButtonsSection
            }
            .navigationBarTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction", displayMode: .inline)
            .onAppear(perform: loadTransaction)
        }
    }
    
    // Preview Section
    private var previewSection: some View {
        Section(header: Text("Preview")) {
            TransactionsCardView(transactions: .init(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, classification: classification, assignColour: assignColour))
        }
    }
    
    // Transaction Details Section
    private var transactionDetailsSection: some View {
        Section(header: Text("Transaction Details").foregroundColor(.secondary)) {
            categoryPicker
            remarksTextField
            amountField
            datePicker
        }
    }
    
    // Classification Picker Section
    private var classificationPickerSection: some View {
        Section {
            ClassificationPicker(classification: $classification)
        }
    }
    
    // Action Buttons Section
    private var actionButtonsSection: some View {
        Section {
            Button("Save", action: saveTransaction)
            if editTransaction != nil {
                Button("Delete", role: .destructive, action: deleteTransaction)
            }
        }
    }
    
    // Category Picker
    private var categoryPicker: some View {
        Picker("Category", selection: $selectedType) {
            ForEach(TransactionTypes.allCases, id: \.self) { type in
                HStack {
                    type.transactionIcon
                    Text(type.rawValue)
                }
                .tag(type)
            }
        }
        .pickerStyle(.automatic)
        .onChange(of: selectedType) { newValue in
            title = newValue.rawValue // Update title when category changes
        }
    }
    
    // TextField for entering transaction remarks
    private var remarksTextField: some View {
        TextField("Description", text: $remarks)
    }
    
    // TextField for entering transaction amount
    private var amountField: some View {
        HStack {
            Text("$").foregroundColor(.secondary)
            TextField("Amount", value: $amount, formatter: numberFormatter)
                .keyboardType(.decimalPad)
        }
    }
    
    // DatePicker for selecting transaction date
    private var datePicker: some View {
        DatePicker("Date", selection: $dateAdded, displayedComponents: .date)
    }
    
    // Load existing transaction data if editing
    private func loadTransaction() {
        if let editTransaction = editTransaction {
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
    
    // Save new or update existing transaction
    private func saveTransaction() {
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
    
    // Delete existing Transaction
    private func deleteTransaction() {
        if let editTransaction = editTransaction {
            context.delete(editTransaction)
            dismiss()
        }
    }
    
    // Classification Picker Component
    private struct ClassificationPicker: View {
        @Binding var classification: Classification
        
        var body: some View {
            Picker("Classification", selection: $classification) {
                ForEach(Classification.allCases, id: \.self) { classification in
                    Text(classification.rawValue).tag(classification)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // Formatter for amount input, allowing only 2 decimal places
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

// Extension to provide icons for transaction types
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
            Image(systemName: "film")
        case .salary:
            Image(systemName: "dollarsign.square.fill")
        case .other:
            Image(systemName: "doc.questionmark")
        }
    }
}

#Preview {
    NavigationStack {
        AddTransactionView()
    }
}
