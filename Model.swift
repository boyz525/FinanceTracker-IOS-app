//
//  FinanceModel.swift
//  FinancesF
//
//  Created by Александр Малахов on 31.03.2026.
//

import Foundation
import SwiftData

@Model
final class Operation{
    var id:UUID
    var amount:Float
    var date:Date
    var opType:OpType
    
    init(id: UUID, amount: Float, date: Date, opType: OpType) {
        self.id = id
        self.amount = amount
        self.date = date
        self.opType = opType
    }
    

}

enum OpType:String {
    case expence = "expence"
    case income = "income"
}

