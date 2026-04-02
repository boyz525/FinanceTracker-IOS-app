//
//  TransactionViewModel.swift
//  FinancesF
//
//  Created by Александр Малахов on 31.03.2026.
//


import Observation
import Foundation

@MainActor
@Observable
final class TransactionViewModel {

    private(set) var transactions: [Transaction] = []
    private(set) var isLoading = false
    private(set) var error: String?

    var selectedCategory: TransactionCategory? = nil
    var selectedPeriod: Period = .month

    enum Period: String, CaseIterable {
        case week  = "Неделя"
        case month = "Месяц"
        case year  = "Год"
        case all   = "Всё"
    }

    private let repository: TransactionRepository

    init(repository: TransactionRepository) {
        self.repository = repository
    }

    func load() {
        isLoading = true
        do {
            transactions = try repository.fetchAll()
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func add(title: String, amount: Decimal, category: TransactionCategory, note: String?, date: Date, opType: OpType) {
        let t = Transaction(opTitle: title, amount: amount, date: date, category: category, note: note, opType: opType)
        repository.insert(t)
        load()
    }

    func delete(_ transaction: Transaction) {
        repository.delete(transaction)
        load()
    }

    func update(_ transaction: Transaction) {
        repository.update(transaction)
        load()
    }

    var filteredTransactions: [Transaction] {
        let byPeriod = transactions.filter { inSelectedPeriod($0.date) }
        guard let cat = selectedCategory else { return byPeriod }
        return byPeriod.filter { $0.category == cat }
    }

    var totalIncome: Decimal {
        filteredTransactions
            .filter { $0.opType == .income }
            .reduce(0) { $0 + $1.amount }
    }

    var totalExpenses: Decimal {
        filteredTransactions
            .filter { $0.opType == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    var balance: Decimal {
        totalIncome - totalExpenses
    }


    var categoryBreakdown: [CategoryBreakdown] {
        let expenses = filteredTransactions.filter { $0.opType == .expense }
        let total = expenses.reduce(Decimal(0)) { $0 + $1.amount }
        guard total > 0 else { return [] }

        let grouped = Dictionary(grouping: expenses, by: \.category)
        return grouped.map { cat, txns in
            let sum = txns.reduce(Decimal(0)) { $0 + $1.amount }
            let pct = NSDecimalNumber(decimal: sum / total).doubleValue
            return CategoryBreakdown(category: cat, total: sum, percentage: pct)
        }
        .sorted { $0.total > $1.total }
    }

    var dailySpending: [DailySpending] {
        let calendar = Calendar.current
        let expenses = filteredTransactions.filter { $0.opType == .expense }
        let grouped = Dictionary(
            grouping: expenses,
            by: { calendar.startOfDay(for: $0.date) }
        )
        return grouped.map { day, txns in
            DailySpending(
                date: day,
                total: txns.reduce(0) { $0 + $1.amount }
            )
        }
        .sorted { $0.date < $1.date }
    }

    var monthlyBalance: [MonthlyBalance] {
        let calendar = Calendar.current
        let grouped = Dictionary(
            grouping: transactions,
            by: { calendar.date(from: calendar.dateComponents([.year, .month], from: $0.date))! }
        )
        return grouped.map { month, txns in
            let inc = txns.filter { $0.opType == .income }.reduce(Decimal(0)) { $0 + $1.amount }
            let exp = txns.filter { $0.opType == .expense }.reduce(Decimal(0)) { $0 + $1.amount }
            return MonthlyBalance(month: month, income: inc, expenses: exp)
        }
        .sorted { $0.month < $1.month }
    }

    private func inSelectedPeriod(_ date: Date) -> Bool {
        let now = Date.now
        let calendar = Calendar.current
        switch selectedPeriod {
        case .week:
            return calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear)
        case .month:
            return calendar.isDate(date, equalTo: now, toGranularity: .month)
        case .year:
            return calendar.isDate(date, equalTo: now, toGranularity: .year)
        case .all:
            return true
        }
    }
}
