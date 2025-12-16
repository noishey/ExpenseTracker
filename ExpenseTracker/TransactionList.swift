//
//  TransactionList.swift
//  ExpenseTracker
//
//  Created by Arjun Shenoy on 16/12/25.
//

import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    var body: some View {
        VStack{
            List {
                // MARK: Transaction Groups
                let groups = transactionListVM.groupTransactionsByMonth()
                ForEach(groups.sorted(by: { $0.key > $1.key }), id: \.key) { month, transactions in
                    Section {
                        // MARK: Transaction List
                        ForEach(transactions, id: \.id) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    } header: {
                        // MARK: Transaction Month
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Light") {
    let transactionListVM = TransactionListViewModel()
    transactionListVM.transactions = transactionListPreviewData
    return TransactionList()
        .environmentObject(transactionListVM)
}

#Preview("Dark") {
    let transactionListVM = TransactionListViewModel()
    transactionListVM.transactions = transactionListPreviewData
    return TransactionList()
        .environmentObject(transactionListVM)
        .preferredColorScheme(.dark)
}

