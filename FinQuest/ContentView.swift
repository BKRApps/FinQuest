//
//  ContentView.swift
//  FinQuest
//
//  Created by Kumar on 05/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "dollarsign.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.green)
                    .font(.system(size: 60))
                
                Text("FinQuest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your Personal Finance Tracker")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    showingAddTransaction = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Transaction")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("FinQuest")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView()
        }
    }
}

#Preview {
    ContentView()
}
