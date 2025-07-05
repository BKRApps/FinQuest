//
//  Transaction.swift
//  FinQuest
//
//  Created by Kumar on 05/07/25.
//

import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    let type: TransactionType
    var date: Date
    var category: String
    var subCategory: String?
    var comments: String?
    var amount: Double
    
    init(type: TransactionType, date: Date = Date(), category: String, subCategory: String? = nil, comments: String? = nil, amount: Double) {
        id = UUID()
        self.type = type
        self.date = date
        self.category = category
        self.subCategory = subCategory
        self.comments = comments
        self.amount = amount
    }
} 
