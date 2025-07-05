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
    let date: Date
    let category: String
    let subCategory: String?
    let comments: String?
    let amount: Double
    
    init(id: UUID = UUID(), type: TransactionType, date: Date = Date(), category: String, subCategory: String? = nil, comments: String? = nil, amount: Double) {
        self.id = id
        self.type = type
        self.date = date
        self.category = category
        self.subCategory = subCategory
        self.comments = comments
        self.amount = amount
    }
} 
