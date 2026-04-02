//
//  TodaySummaryView.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//

import SwiftUI
import SwiftData
import Foundation

struct TodaySummaryView: View {
    @Query private var allTransactions: [Transaction]

    private var todayTransactions: [Transaction] {
        let start = Calendar.current.startOfDay(for: .now)
        return allTransactions.filter { $0.date >= start }
    }

    private var todayIncome: Double {
        todayTransactions
            .filter { $0.opType == .income }
            .reduce(0) { $0 + NSDecimalNumber(decimal: $1.amount).doubleValue }
    }

    private var todayExpense: Double {
        todayTransactions
            .filter { $0.opType == .expense }
            .reduce(0) { $0 + NSDecimalNumber(decimal: $1.amount).doubleValue }
    }

    private var diff: Double { todayIncome - todayExpense }

    var body: some View {
        if todayTransactions.isEmpty {
            Text("Операций сегодня не было")
                .foregroundStyle(.white.opacity(0.5))
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 16)
        } else {
            HStack(spacing: 20) {
                SummaryPill(
                    icon: "arrowshape.up.circle.fill",
                    value: todayIncome,
                    color: .green
                )
                SummaryPill(
                    icon: "arrowshape.down.circle.fill",
                    value: todayExpense,
                    color: .red
                )
                SummaryPill(
                    icon: diff >= 0 ? "plus.minus" : "minus",
                    value: abs(diff),
                    color: diff >= 0 ? .blue : .orange,
                    prefix: diff >= 0 ? "+" : "−"
                )
            }
            .padding(.vertical, 12)
            .frame(width: 390, height: 100)
        }
    }
}

private struct SummaryPill: View {
    let icon: String
    let value: Double
    let color: Color
    var prefix: String = ""

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 35, weight: .semibold))
                .foregroundStyle(color)
            Text("\(prefix)\(value.compactFormatted)")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .glassEffect(.clear.tint(color.opacity(0.25)).interactive(), in: RoundedRectangle(cornerRadius: 25))
    }
}

private extension Double {
    var compactFormatted: String {
        switch self {
        case 1_000_000...: return String(format: "%.1fм", self / 1_000_000)
        case 1_000...:     return String(format: "%.0f", self )
        default:           return String(format: "%.0f", self)
        }
    }
}

#Preview {
    TodaySummaryView()
        .modelContainer(for: Transaction.self, inMemory: true)
        .background(.black)
}
