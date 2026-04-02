//
//  TransactionCellView.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//

import SwiftUI
import SwiftData
import Foundation

struct TransactionCellView: View {
    let item: Transaction
    var onTap: (() -> Void)? = nil

    private var amountDouble: Double {
        NSDecimalNumber(decimal: item.amount).doubleValue
    }

    private var dateFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "dd.MM  HH:mm"
        return f.string(from: item.date)
    }

    var body: some View {
        Button { onTap?() } label: {
            HStack(spacing: 14) {
                // Иконка категории
                Image(systemName: item.category.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 40)
                    .glassEffect(
                        .clear.tint((item.opType == .income ? Color.green : Color.red).opacity(0.2)),
                        in: Circle()
                    )

                // Название и дата
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.opTitle)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                    if let note = item.note {
                        Text(note)
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    Text(dateFormatted)
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.4))
                }

                Spacer()

                // Сумма
                Text("\(item.opType == .income ? "+" : "−")\(amountDouble.compactFormatted) ₽")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(item.opType == .income ? .green.opacity(0.9) : .red.opacity(0.9))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 30))
        }
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
    TransactionCellView(item: Transaction(
        opTitle: "Зарплата",
        amount: Decimal(9000),
        category: .other,
        note: "Аванс",
        opType: .income
    ))
    .padding()
    .background(.black)
    .modelContainer(for: Transaction.self, inMemory: true)
}
