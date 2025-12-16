//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Arjun Shenoy on 16/11/25.
//

import SwiftUI
import Charts

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical){
                VStack(alignment: .leading, spacing: 24){
                    //MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    //MARK: Chart
                    LineChart()
                    //MARK: Transaction List
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Notification Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.appIcon, .primary)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview("Light") {
    let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    ContentView()
        .environmentObject(transactionListVM)
}

#Preview("Dark") {
    let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    ContentView()
        .environmentObject(transactionListVM)
        .preferredColorScheme(.dark)
}

