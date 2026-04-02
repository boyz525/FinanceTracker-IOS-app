//
//  Transaction.swift
//  FinancesF
//
//  Created by Александр Малахов on 31.03.2026.
//


import SwiftData
import Foundation

enum TransactionCategory: String, Codable, CaseIterable {
    case food        = "Еда"
    case transport   = "Транспорт"
    case housing     = "Жильё"
    case health      = "Здоровье"
    case entertainment = "Развлечения"
    case other       = "Прочее"

    var icon: String {
        switch self {
        case .food:            return "fork.knife"
        case .transport:       return "car.fill"
        case .housing:         return "house.fill"
        case .health:          return "heart.fill"
        case .entertainment:   return "gamecontroller.fill"
        case .other:           return "ellipsis.circle.fill"
        }
    }
}

enum OpType: String, Codable {
    case income = "income"
    case expense = "expense"
    
    var icon: String{
        switch self{
        case .income: return "tray.and.arrow.up.fill"
        case .expense: return "tray.and.arrow.down.fill"
        }
    }
    
}

@Model
final class Transaction {
    var opTitle: String
    var id: UUID
    var amount: Decimal
    var date: Date
    var category: TransactionCategory
    var note: String?
    var opType: OpType

    init(
        opTitle: String,
        id: UUID = UUID(),
        amount: Decimal,
        date: Date = .now,
        category: TransactionCategory,
        note: String? = nil,
        opType: OpType
    ) {
        self.opTitle = opTitle
        self.id = id
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
        self.opType = opType
    }
}

