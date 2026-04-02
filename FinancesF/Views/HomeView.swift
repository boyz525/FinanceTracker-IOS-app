//
//  HomeView.swift
//  FinancesF
//
//  Created by Александр Малахов on 02.04.2026.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @Environment(UserSettings.self) private var settings
    var body: some View {
        ZStack {
            AnimatedBackground()

            ScrollView {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Привет, \(settings.userName ?? "Сашка")")
                                .foregroundStyle(.white)
                                .font(.title2)
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            Text("Глянем твои статы 🧐")
                                .foregroundStyle(.white)
                                .font(.title3)
                                .bold()
                                .padding(.horizontal, 20)

                            DailyBarChartView()

                            Rectangle()
                                .fill(.white.opacity(0.15))
                                .frame(height: 1)
                                .padding(.horizontal, 20)

                            TodaySummaryView()
                        
                        }
                        

                        
                    }
                    .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 45))
                    .frame(width: 350)

                    RecentTransactionsView()
                        .padding(.top, 12)
                }
                .ignoresSafeArea()
            }
        }
    }
}

