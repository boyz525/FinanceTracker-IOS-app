//
//  DailyBarChartView.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//

import SwiftUI
import Charts
import SwiftData
import Foundation

private extension Double {
    var compactFormatted: String {
        switch self {
        case 1_000_000...: return String(format: "%.1fм", self / 1_000_000)
        case 1_000...:     return String(format: "%.0fк", self / 1_000)
        default:           return String(format: "%.0f", self)
        }
    }
}

struct DailyBarChartView: View {
    @Query private var transactions: [Transaction]

    private struct DayData: Identifiable {
        let id = UUID()
        let date: Date
        let label: String
        let income: Double
        let expense: Double
    }

    private var dailyData: [DayData] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"

        let today = calendar.startOfDay(for: .now)
        guard let cutoff = calendar.date(byAdding: .day, value: -2, to: today) else { return [] }

        let recent = transactions.filter { $0.date >= cutoff }

        let grouped = Dictionary(
            grouping: recent,
            by: { calendar.startOfDay(for: $0.date) }
        )

        return grouped.map { date, txns in
            let income = txns
                .filter { $0.opType == .income }
                .reduce(0.0) { $0 + NSDecimalNumber(decimal: $1.amount).doubleValue }
            let expense = txns
                .filter { $0.opType == .expense }
                .reduce(0.0) { $0 + NSDecimalNumber(decimal: $1.amount).doubleValue }
            return DayData(
                date: date,
                label: formatter.string(from: date),
                income: income,
                expense: expense
            )
        }
        .sorted { $0.date < $1.date }
    }

    private var yMax: Double {
        (dailyData.map(\.income).max() ?? 1) * 1.08
    }

    var body: some View {
        if dailyData.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(.white.opacity(0.25))
                Text("Ещё не было операций")
                    .foregroundStyle(.white.opacity(0.4))
                    .font(.subheadline)
            }
            .frame(height: 280)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 20)
        } else {
            Chart {
                ForEach(dailyData) { day in

                    BarMark(
                        x: .value("День", day.label),
                        y: .value("Доход", day.income),
                        width: 55,
                        stacking: .unstacked
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green.opacity(0.9), .green.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(16)
                    .annotation(position: .top, spacing: 4) {
                        Text(day.income.compactFormatted)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.green.opacity(0.9))
                    }

                    BarMark(
                        x: .value("День", day.label),
                        y: .value("Расход", day.expense),
                        width: 50,
                        stacking: .unstacked
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red.opacity(0.85), .red.opacity(0.35)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(20)
                    .annotation(position: .bottom, spacing: 4) {
                        Text(day.expense.compactFormatted)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.red.opacity(0.9))
                    }
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.system(size: 20, weight: .medium))
                }
            }
            .chartYAxis(.hidden)
            .chartLegend(.hidden)
            .frame(width: 330, height: 320)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    DailyBarChartView()
        .modelContainer(for: Transaction.self, inMemory: true)
        .background(.black)
}
