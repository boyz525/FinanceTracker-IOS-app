//
//  TransactionDetailSheet.swift
//  FinancesF
//
//  Created by Александр Малахов on 02.04.2026.
//

import SwiftUI
import SwiftData
import Foundation

struct TransactionDetailSheet: View {
    let item: Transaction

    private var amountDouble: Double {
        NSDecimalNumber(decimal: item.amount).doubleValue
    }

    private var dateFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "d MMMM yyyy, HH:mm"
        f.locale = Locale(identifier: "ru_RU")
        return f.string(from: item.date)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Image(systemName: item.category.icon)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundStyle(item.opType == .income ? Color.green : Color.red)
                    .frame(width: 80, height: 80)
                    .glassEffect(
                        .clear.tint((item.opType == .income ? Color.green : Color.red).opacity(0.2)),
                        in: Circle()
                    )
                    .padding(.top, 32)

                Text(item.opTitle)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.primary)
                    .padding(.top, 16)

                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(item.opType == .income ? "+" : "−")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                    Text(amountDouble.compactFormatted)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    Text("₽")
                        .font(.system(size: 28, weight: .semibold))
                }
                .foregroundStyle(item.opType == .income ? Color.green : Color.red)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .padding(.top, 8)
                .padding(.horizontal, 24)

                Rectangle()
                    .fill(.secondary.opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)

                VStack(spacing: 10) {
                    InfoRow(label: "Категория", value: item.category.rawValue, icon: item.category.icon)
                    InfoRow(
                        label: "Тип",
                        value: item.opType == .income ? "Доход" : "Расход",
                        icon: item.opType == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
                    )
                    InfoRow(label: "Дата", value: dateFormatted, icon: "calendar")
                    if let note = item.note {
                        InfoRow(label: "Заметка", value: note, icon: "text.bubble")
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(40)
        .presentationDragIndicator(.visible)
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 24)

            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 16))
    }
}

private extension Double {
    var compactFormatted: String {
        switch self {
        case 1_000_000...: return String(format: "%.1fм", self / 1_000_000)
        case 1_000...:     return String(format: "%.0f", self)
        default:           return String(format: "%.0f", self)
        }
    }
}

#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            TransactionDetailSheet(item: Transaction(
                opTitle: "Зарплата",
                amount: Decimal(9000),
                category: .health,
                note: "Аванс",
                opType: .income
            ))
        }
        .modelContainer(for: Transaction.self, inMemory: true)
}
