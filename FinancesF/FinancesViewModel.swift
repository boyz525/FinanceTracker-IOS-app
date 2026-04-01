//
//  FinancesViewModel.swift
//  FinancesF
//
//  Created by Александр Малахов on 31.03.2026.
//

import Foundation
import SwiftData

@Observable
final class FinanceViewModel {
    var transactions:[Operation] = []
    
    private var context: ModelContext
  
    init(context: ModelContext) {
        self.context = context
        load()
    }

    
    func load(){
        let descriptor = FetchDescriptor<Operation>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        transactions = (try? context.fetch(descriptor)) ?? []
    }
    
    func add(amount: Float, TType: OpType) {
        let trans = Operation( id: UUID(), amount: amount, date: Date(), opType: TType)
        context.insert(trans)
        load()
    }

    func delete(_ trans: Operation) {
        context.delete(trans)
        load()
    }
}
    

