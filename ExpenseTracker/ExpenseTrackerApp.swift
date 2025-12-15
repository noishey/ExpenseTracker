//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Arjun Shenoy on 16/11/25.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
