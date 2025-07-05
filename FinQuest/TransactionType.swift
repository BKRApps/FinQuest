//
//  TransactionType.swift
//  FinQuest
//
//  Created by Kumar on 05/07/25.
//

import Foundation

enum TransactionType: String, CaseIterable, Codable {
    case income = "Income"
    case expense = "Expense"
    case savings = "Savings"
    
    var categories: [String] {
        switch self {
        case .income:
            return ["Salary", "Rent", "Other Income", "Profits"]
        case .expense:
            return ["Shopping", "Groceries", "Home Expenses", "Main Expenses", "School Fees", "Play", "Sports", "Party", "Trips/Vacation"]
        case .savings:
            return ["SIP", "Fixed Deposit", "Recurring Deposit", "Lumpsum Investment", "Other Savings"]
        }
    }
} 
