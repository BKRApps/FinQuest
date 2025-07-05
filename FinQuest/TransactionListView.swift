//
//  TransactionListView.swift
//  FinQuest
//
//  Created by Kumar on 05/07/25.
//

import SwiftUI

struct TransactionListView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var transactions: [Transaction] = []
    
    var body: some View {
        NavigationView {
            List {
                if transactions.isEmpty {
                    ContentUnavailableView(
                        "No Transactions",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Add your first transaction to get started")
                    )
                } else {
                    ForEach(transactions) { transaction in
                        TransactionRowView(transaction: transaction)
                    }
                    .onDelete(perform: deleteTransactions)
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        coreDataManager.deleteAllTransactions()
                        loadTransactions()
                    }
                    .foregroundColor(.red)
                    .disabled(transactions.isEmpty)
                }
            }
        }
        .onAppear {
            loadTransactions()
        }
    }
    
    private func loadTransactions() {
        transactions = coreDataManager.fetchTransactions()
    }
    
    private func deleteTransactions(offsets: IndexSet) {
        for index in offsets {
            let transaction = transactions[index]
            coreDataManager.deleteTransaction(withId: transaction.id)
        }
        loadTransactions()
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: transaction.amount)) ?? "₹\(transaction.amount)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.category)
                        .font(.headline)
                    if let subCategory = transaction.subCategory {
                        Text(subCategory)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(formattedAmount)
                        .font(.headline)
                        .foregroundColor(transaction.type == .income ? .green : .red)
                    
                    Text(transaction.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let comments = transaction.comments {
                    Text(comments)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TransactionListView()
} 