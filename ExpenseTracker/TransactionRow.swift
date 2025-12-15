//
//  TransactionRow.swift
//  ExpenseTracker
//
//  Created by Arjun Shenoy on 14/12/25.
//

import SwiftUI
import SwiftUIFontIcon

struct TransactionRow: View {
    var transaction: Transaction
    var body: some View {
        HStack(spacing: 20) {
            // MARK: Transaction Category Icon
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.icon.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay{
                    FontIcon.text(.awesome5Solid(code: transaction.icon), fontsize: 24, color: Color.icon)
                }
            VStack(alignment: .leading, spacing: 6) {
                // MARK: Transaction Merchant
                Text(transaction.merchant)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                // MARK: Transaction Category
                Text(transaction.category)
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                // MARK: Transaction Date
                Text(transaction.dateParsed, format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            // MARK: Transaction Amount
            Text(transaction.signedAmount, format: .currency(code: "USD"))
                .bold()
                .foregroundColor(transaction.type == TransactionType.credit.rawValue ? Color.text : Color.primary)
        }
        .padding([.top, .bottom], 8)
    }
}

#Preview("Light") {
    TransactionRow(transaction: transactionPreviewData)
        .previewDisplayName("Light")
        .preferredColorScheme(.light)
        .previewLayout(.device)
}
#Preview("Dark") {
    TransactionRow(transaction: transactionPreviewData)
        .previewDisplayName("Dark")
        .preferredColorScheme(.dark)
        .previewLayout(.device)
}
