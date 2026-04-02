//
//  ChartModels.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//


import Foundation

struct CategoryBreakdown: Identifiable {
    let id = UUID()
    let category: TransactionCategory
    let total: Decimal
    let percentage: Double
}

struct DailySpending: Identifiable {
    let id = UUID()
    let date: Date
    let total: Decimal
}

struct MonthlyBalance: Identifiable {
    let id = UUID()
    let month: Date   
    let income: Decimal
    let expenses: Decimal
    var balance: Decimal { income - expenses }
}
