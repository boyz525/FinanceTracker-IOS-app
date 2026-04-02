//
//  RecentTransactionsView.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//

import SwiftUI
import SwiftData

struct RecentTransactionsView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var allTransactions: [Transaction]
    @State private var selectedItem: Transaction? = nil

    private var items: [Transaction] { Array(allTransactions.prefix(10)) }

    var body: some View {
        if items.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "tray")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(.white.opacity(0.3))
                Text("Операций пока нет")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                Text("Добавь первую транзакцию во вкладке Pay")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
            .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 45))
        } else {
            VStack(alignment: .leading, spacing: 0) {
                Text("Последние операции")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.horizontal, 100)
                    .padding(.top, 16)
                    .padding(.bottom, 10)

                VStack(spacing: 8) {
                    ForEach(items) { item in
                        TransactionCellView(item: item, onTap: { selectedItem = item })
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 16)
            }
            .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 45))
            .sheet(item: $selectedItem) { item in
                TransactionDetailSheet(item: item)
            }
        }
    }
}

#Preview {
    ScrollView {
        RecentTransactionsView()
            .padding()
    }
    .background(.black)
    .modelContainer(for: Transaction.self, inMemory: true)
}
