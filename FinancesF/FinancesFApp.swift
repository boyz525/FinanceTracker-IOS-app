//
//  FinancesFApp.swift
//  FinancesF
//
//  Created by Александр Малахов on 31.03.2026.
//


import SwiftUI
import SwiftData

@main
struct FinancesFApp: App {
    @State private var settings = UserSettings()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(settings)
        }
        .modelContainer(for: Transaction.self)
    }
}
