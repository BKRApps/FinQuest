//
//  AddTransactionView.swift
//  FinQuest
//
//  Created by Kumar on 05/07/25.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var selectedType: TransactionType = .expense
    @State private var selectedDate = Date()
    @State private var selectedCategory = ""
    @State private var subCategory = ""
    @State private var comments = ""
    @State private var amount = ""
    @State private var showingDatePicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                // Transaction Type Section
                Section("Transaction Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedType) { _ in
                        // Reset category when type changes
                        selectedCategory = ""
                    }
                }
                
                // Date Section
                Section("Date & Time") {
                    HStack {
                        Text(selectedDate, style: .date)
                        Spacer()
                        Button("Change") {
                            showingDatePicker.toggle()
                        }
                        .foregroundColor(.blue)
                    }
                    
                    if showingDatePicker {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.graphical)
                    }
                }
                
                // Category Section
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select Category").tag("")
                        ForEach(selectedType.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Sub Category Section
                Section("Sub Category (Optional)") {
                    TextField("Enter sub category", text: $subCategory)
                }
                
                // Amount Section
                Section("Amount (₹)") {
                    HStack {
                        Text("₹")
                            .foregroundColor(.secondary)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                }
                
                // Comments Section
                Section("Comments (Optional)") {
                    TextField("Enter comments", text: $comments, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                // Save Button Section
                Section {
                    Button(action: saveTransaction) {
                        HStack {
                            Spacer()
                            Text("Save Transaction")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                    .disabled(selectedCategory.isEmpty || amount.isEmpty)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Transaction", isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage.contains("saved") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount), !selectedCategory.isEmpty else {
            alertMessage = "Please fill in all required fields"
            showingAlert = true
            return
        }
        
        let transaction = Transaction(
            type: selectedType,
            date: selectedDate,
            category: selectedCategory,
            subCategory: subCategory.isEmpty ? nil : subCategory,
            comments: comments.isEmpty ? nil : comments,
            amount: amountValue
        )
        
        // Save to Core Data
        coreDataManager.addTransaction(transaction)
        
        alertMessage = "Transaction saved successfully!"
        showingAlert = true
    }
}

#Preview {
    AddTransactionView()
} 