//
//  CoreDataManager.swift
//  FinQuest
//
//  Created by Kumar on 05/07/25.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FinQuest")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func addTransaction(_ transaction: Transaction) {
        let context = container.viewContext
        let entity = TransactionEntity(context: context)
        
        entity.id = transaction.id
        entity.type = transaction.type.rawValue
        entity.date = transaction.date
        entity.category = transaction.category
        entity.subCategory = transaction.subCategory
        entity.comments = transaction.comments
        entity.amount = transaction.amount
        
        save()
    }
    
    func fetchTransactions() -> [Transaction] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)]
        
        do {
            let entities = try container.viewContext.fetch(request)
            return entities.compactMap { entity in
                guard let typeString = entity.type,
                      let type = TransactionType(rawValue: typeString),
                      let id = entity.id else {
                    return nil
                }
                
                return Transaction(
                    id: id,
                    type: type,
                    date: entity.date ?? Date(),
                    category: entity.category ?? "",
                    subCategory: entity.subCategory,
                    comments: entity.comments,
                    amount: entity.amount
                )
            }
        } catch {
            print("Error fetching transactions: \(error)")
            return []
        }
    }
    
    func deleteTransaction(withId id: UUID) {
        let context = container.viewContext
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            for entity in entities {
                context.delete(entity)
            }
            save()
        } catch {
            print("Error deleting transaction: \(error)")
        }
    }
    
    func deleteAllTransactions() {
        let context = container.viewContext
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            for entity in entities {
                context.delete(entity)
            }
            save()
        } catch {
            print("Error deleting all transactions: \(error)")
        }
    }
} 