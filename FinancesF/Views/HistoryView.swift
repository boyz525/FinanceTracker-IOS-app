//
//  HistoryView.swift
//  FinancesF
//
//  Created by Александр Малахов on 02.04.2026.
//

import SwiftUI
import SwiftData
import Foundation

private enum HistoryPeriod: String, CaseIterable {
    case week  = "Неделя"
    case month = "Месяц"
    case year  = "Год"
    case all   = "Всё"
}

struct HistoryView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var allTransactions: [Transaction]
    @State private var selectedPeriod: HistoryPeriod = .month
    @State private var selectedItem: Transaction? = nil

    private var filteredItems: [Transaction] {
        let cal = Calendar.current
        let now = Date.now
        return allTransactions.filter { item in
            switch selectedPeriod {
            case .week:
                guard let cutoff = cal.date(byAdding: .day, value: -7, to: now) else { return false }
                return item.date >= cutoff
            case .month:
                guard let cutoff = cal.date(byAdding: .month, value: -1, to: now) else { return false }
                return item.date >= cutoff
            case .year:
                guard let cutoff = cal.date(byAdding: .year, value: -1, to: now) else { return false }
                return item.date >= cutoff
            case .all:
                return true
            }
        }
    }

    private var groupedItems: [(header: String, items: [Transaction])] {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: filteredItems) {
            cal.startOfDay(for: $0.date)
        }
        let f = DateFormatter()
        f.dateFormat = "d MMMM"
        f.locale = Locale(identifier: "ru_RU")

        return grouped
            .sorted { $0.key > $1.key }
            .map { date, txns in
                let header: String
                if cal.isDateInToday(date)          { header = "Сегодня" }
                else if cal.isDateInYesterday(date) { header = "Вчера" }
                else                                { header = f.string(from: date) }
                return (header: header, items: txns.sorted { $0.date > $1.date })
            }
    }

    private var periodIncome: Double {
        filteredItems
            .filter { $0.opType == .income }
            .reduce(0) { $0 + NSDecimalNumber(decimal: $1.amount).doubleValue }
    }

    private var periodExpense: Double {
        filteredItems
            .filter { $0.opType == .expense }
            .reduce(0) { $0 + NSDecimalNumber(decimal: $1.amount).doubleValue }
    }

    var body: some View {
        ZStack {
            AnimatedBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    Text("История")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                    HistoryPeriodFilterRow(selected: $selectedPeriod)

                    HistorySummaryBar(income: periodIncome, expense: periodExpense)
                        .padding(.horizontal, 20)

                    if groupedItems.isEmpty {
                        HistoryEmptyView()
                            .padding(.top, 60)
                    } else {
                        HistoryGroupedList(groups: groupedItems, onTap: { selectedItem = $0 })
                            .padding(.horizontal, 14)
                    }

                    Spacer(minLength: 40)
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            TransactionDetailSheet(item: item)
        }
    }
}


private struct HistoryPeriodFilterRow: View {
    @Binding var selected: HistoryPeriod

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(HistoryPeriod.allCases, id: \.self) { period in
                    Button {
                        withAnimation(.spring(duration: 0.2)) { selected = period }
                    } label: {
                        Text(period.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selected == period ? .white : .white.opacity(0.45))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .glassEffect(
                                .clear.tint(selected == period ? Color.purple.opacity(0.4) : Color.clear).interactive(),
                                in: Capsule()
                            )
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 4)
        }
    }
}

private struct HistorySummaryBar: View {
    let income: Double
    let expense: Double

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "arrowshape.up.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.green)
                Text(income.compactFormatted + " ₽")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .glassEffect(.clear.tint(Color.green.opacity(0.15)), in: RoundedRectangle(cornerRadius: 20))

            HStack(spacing: 6) {
                Image(systemName: "arrowshape.down.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.red)
                Text(expense.compactFormatted + " ₽")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .glassEffect(.clear.tint(Color.red.opacity(0.15)), in: RoundedRectangle(cornerRadius: 20))
        }
    }
}

private struct HistoryGroupedList: View {
    let groups: [(header: String, items: [Transaction])]
    let onTap: (Transaction) -> Void

    var body: some View {
        VStack(spacing: 20) {
            ForEach(groups, id: \.header) { group in
                VStack(alignment: .leading, spacing: 8) {
                    Text(group.header)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.leading, 8)

                    VStack(spacing: 8) {
                        ForEach(group.items) { item in
                            TransactionCellView(item: item, onTap: { onTap(item) })
                        }
                    }
                }
            }
        }
    }
}

private struct HistoryEmptyView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.25))
            Text("Ещё нет операций")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
            Text("Добавь первую транзакцию во вкладке Pay")
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.25))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
    }
}

private extension Double {
    var compactFormatted: String {
        switch self {
        case 1_000_000...: return String(format: "%.1fм", self / 1_000_000)
        case 1_000...:     return String(format: "%.0fк", self / 1_000)
        default:           return String(format: "%.0f", self)
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
