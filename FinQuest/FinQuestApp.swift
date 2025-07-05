//
//  FinQuestApp.swift
//  FinQuest
//
//  Created by Kumar on 05/07/25.
//

import SwiftUI

@main
struct FinQuestApp: App {
    @StateObject private var coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
