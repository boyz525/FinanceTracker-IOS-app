//
//  FinanceModel.swift
//  FinancesF
//
//  Created by Александр Малахов on 31.03.2026.
//

import Foundation
import SwiftData


struct transaction: Identifiable, Hashable, Codable {
    
    var id: UUID
    var amount: Double
    var date: Date
    var note: String?
    var type: TransactionType
    var category: Category
      
    init(amount: Double, date: Date, type: TransactionType, category: Category, note: String? = nil) {
        self.id = UUID() // Генерируем уникальный ID при создании
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
        self.note = note
    }
}

enum TransactionType: String, Codable, CaseIterable {
    case income = "Доход"
    case expense = "Расход"
    var icon: String {
        switch self {
        case .income: return "arrow.down.circle.fill"
        case .expense: return "arrow.up.circle.fill"
        }
    }
}

enum Category: String, Codable, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case food = "Еда"
    case transport = "Транспорт"
    case salary = "Зарплата"
    case home = "Дом"
    case entertainment = "Развлечения"
    case health = "Здоровье"
    case taxes = "Налоги"
    case education = "Образование"
    case other = "Прочее"
}
