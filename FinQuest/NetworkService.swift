//
//  NetworkService.swift
//  FinQuest
//
//  Created by Kumar on 05/07/25.
//

import Foundation

struct TransactionRequest: Codable {
    let amount: Double
    let type: String
    let category: String
    let subcategory: String?
    let comments: String?
    let userId: Int
    
    init(transaction: Transaction, userId: Int = 1) {
        self.amount = transaction.amount
        self.type = transaction.type.rawValue
        self.category = transaction.category
        self.subcategory = transaction.subCategory
        self.comments = transaction.comments
        self.userId = userId
    }
}

struct TransactionResponse: Codable {
    let message: String
    let transaction: TransactionData
}

struct TransactionData: Codable {
    let id: Int
    let amount: String
    let type: String
    let category: String
    let subcategory: String?
    let comments: String?
    let date: String
    let userId: Int
    let createdAt: String
    let updatedAt: String
}

class NetworkService: ObservableObject {
    static let shared = NetworkService()
    
    private let baseURL = "https://finquestbackend-production.up.railway.app"
    
    private init() {}
    
    func saveTransaction(_ transaction: Transaction, completion: @escaping (Result<TransactionResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/transactions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let transactionRequest = TransactionRequest(transaction: transaction)
        
        do {
            let jsonData = try JSONEncoder().encode(transactionRequest)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(TransactionResponse.self, from: data)
                        completion(.success(response))
                    } catch {
                        completion(.failure(NetworkError.decodingError(error)))
                    }
                }
            }.resume()
        } catch {
            completion(.failure(NetworkError.encodingError(error)))
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case noData
    case encodingError(Error)
    case decodingError(Error)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data received from server"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
} 