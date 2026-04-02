//
//  TransactionRepository.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//


import SwiftData
import Foundation

@MainActor
final class TransactionRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [Transaction] {
        let descriptor = FetchDescriptor<Transaction>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func insert(_ transaction: Transaction) {
        context.insert(transaction)
        try? context.save()
    }

    func delete(_ transaction: Transaction) {
        context.delete(transaction)
        try? context.save()
    }

    func update(_ transaction: Transaction) {
        try? context.save()
    }
}
