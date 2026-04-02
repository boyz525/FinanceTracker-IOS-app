//
//  HomeView.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(UserSettings.self) private var settings

    var body: some View {
        
        TabView{
            Tab("История", systemImage: "clock.fill"){
                HistoryView()
            }
            Tab("Home", systemImage: "house.fill"){
                HomeView()
            }
            Tab("Pay", systemImage: "rublesign"){
                PayView()
            }
        }
        
    }
}

#Preview {
    MainView()
        .environment(UserSettings())
        .modelContainer(for: Transaction.self, inMemory: true)
}
