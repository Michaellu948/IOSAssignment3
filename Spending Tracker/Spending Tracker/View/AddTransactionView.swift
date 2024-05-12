//
//  AddTransactionView.swift
//  Spending Tracker
//
//  Created by JohnTSS on 7/5/2024.
//
import SwiftUI

// View for adding or editing a transaction in the Spending Tracker app.
struct AddTransactionView: View {
    @Environment(\.modelContext) private var context // Access to the CoreData managed object context.
    @Environment(\.dismiss) private var dismiss // Dismissal handler for closing the view.
    var editTransaction: Transactions? // Optional property to hold an existing transaction for editing.

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
                // Section for displaying a preview of the transaction card.
                Section(header: Text("Preview")) {
                    TransactionsCardView(transactions: .init(title: title, remarks: remarks.isEmpty ? "" : remarks, amount: amount, dateAdded: dateAdded, classification: classification, assignColour: assignColour))
                }
                // Section for transaction inputs
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
                    .onChange(of: selectedType){ newValue in
                        title = newValue.rawValue // Update title when category changes
                    }

                    TextField("Description", text: $remarks)
                    
                    HStack {
                        Text("$").foregroundColor(.secondary)
                        TextField("Amount", value: $amount, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                    }
                    DatePicker("Date", selection: $dateAdded, displayedComponents: .date)
                }
                
                //Section for selecting classification of transaction. (Income / Expense)
                Section {
                    ClassificationPicker(classification: $classification)
                }

                //Section for Save and Delete buttons
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
        .onAppear(perform: loadTransaction) // Load existing data if editing
    }

    // Loads data from an existing transaction into the form if one is being edited.
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
    
    // Saves new or updates existing transaction to CoreData.
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
    
    // Deletes current transaction
    func deleteTransaction() {
        if let editTransaction = editTransaction {
            context.delete(editTransaction)
            dismiss()
        }
    }

    // Picker view for selecting transaction classification. (Income / Expense)
    struct ClassificationPicker: View {
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
    
    // Formatter for amount input. Only allow 2 decimal places.
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
}

// Extension to provides icons from transaction types.
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
