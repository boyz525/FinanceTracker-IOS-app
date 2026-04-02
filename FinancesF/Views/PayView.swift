//
//  PayView.swift
//  FinancesF
//
//  Created by Александр Малахов on 02.04.2026.
//

import SwiftUI
import SwiftData
import Foundation

struct PayView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var opType: OpType = .expense
    @State private var amountText: String = ""
    @State private var selectedCategory: TransactionCategory = .other
    @State private var titleText: String = ""
    @State private var noteText: String = ""
    @FocusState private var amountFocused: Bool

    private var displayAmount: String {
        guard !amountText.isEmpty, let val = Double(amountText) else { return "0" }
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "ru_RU")
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: val)) ?? "0"
    }

    private var canSave: Bool {
        guard let val = Double(amountText) else { return false }
        return val > 0
    }

    private var resolvedTitle: String {
        let trimmed = titleText.trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty ? selectedCategory.rawValue : trimmed
    }

    var body: some View {
        ZStack {
            AnimatedBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {

                    // Заголовок
                    Text("Новая операция")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                    // Переключатель Расход / Доход
                    HStack(spacing: 0) {
                        Button {
                            withAnimation(.spring(duration: 0.25)) { opType = .expense }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.down.circle.fill")
                                Text("Расход")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(opType == .expense ? .white : .white.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                        }

                        Button {
                            withAnimation(.spring(duration: 0.25)) { opType = .income }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.up.circle.fill")
                                Text("Доход")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(opType == .income ? .white : .white.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                        }
                    }
                    .glassEffect(
                        .clear.tint(opType == .income ? Color.green.opacity(0.18) : Color.red.opacity(0.18)).interactive(),
                        in: Capsule()
                    )
                    .padding(.horizontal, 24)

                    ZStack {
                        TextField("", text: $amountText)
                            .keyboardType(.numberPad)
                            .focused($amountFocused)
                            .opacity(0)
                            .frame(width: 1, height: 1)
                            .onChange(of: amountText) { _, new in
                                amountText = String(new.filter { $0.isNumber })
                            }

                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                            Text(displayAmount)
                                .font(.system(size: 64, weight: .bold, design: .rounded))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Text("₽")
                                .font(.system(size: 28, weight: .semibold))
                        }
                        .foregroundStyle(amountText.isEmpty ? .white.opacity(0.3) : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                    }
                    .glassEffect(
                        .clear.tint(opType == .income ? Color.green.opacity(0.08) : Color.red.opacity(0.08)),
                        in: RoundedRectangle(cornerRadius: 28)
                    )
                    .padding(.horizontal, 24)
                    .onTapGesture { amountFocused = true }

                    // Выбор категории
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Категория")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.leading, 28)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(TransactionCategory.allCases, id: \.self) { cat in
                                    Button {
                                        withAnimation(.spring(duration: 0.2)) {
                                            selectedCategory = cat
                                        }
                                    } label: {
                                        VStack(spacing: 6) {
                                            Image(systemName: cat.icon)
                                                .font(.system(size: 22, weight: .medium))
                                            Text(cat.rawValue)
                                                .font(.system(size: 11, weight: .medium))
                                        }
                                        .foregroundStyle(selectedCategory == cat ? .white : .white.opacity(0.5))
                                        .frame(width: 72, height: 72)
                                        .glassEffect(
                                            .clear.tint(selectedCategory == cat ? Color.purple.opacity(0.35) : Color.clear).interactive(),
                                            in: RoundedRectangle(cornerRadius: 20)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }

                    // Поле названия
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Название")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.leading, 4)

                        TextField(selectedCategory.rawValue, text: $titleText)
                            .font(.system(size: 17))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .glassEffect(
                                .clear.tint(.white.opacity(0.05)).interactive(),
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                    }
                    .padding(.horizontal, 24)

                    // Поле заметки
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Заметка")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.leading, 4)

                        TextField("Необязательно", text: $noteText)
                            .font(.system(size: 17))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .glassEffect(
                                .clear.tint(.white.opacity(0.05)).interactive(),
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                    }
                    .padding(.horizontal, 24)

                    // Кнопка сохранить
                    Button {
                        saveTransaction()
                    } label: {
                        Text("Сохранить")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(canSave ? .white : .white.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                    }
                    .glassEffect(
                        .clear.tint((opType == .income ? Color.green : Color.red).opacity(canSave ? 0.3 : 0.08)).interactive(),
                        in: RoundedRectangle(cornerRadius: 20)
                    )
                    .disabled(!canSave)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onAppear { amountFocused = true }
    }

    private func saveTransaction() {
        guard let val = Double(amountText), val > 0 else { return }
        let tx = Transaction(
            opTitle: resolvedTitle,
            amount: Decimal(val),
            category: selectedCategory,
            note: noteText.trimmingCharacters(in: .whitespaces).isEmpty ? nil : noteText,
            opType: opType
        )
        modelContext.insert(tx)
        resetForm()
    }

    private func resetForm() {
        withAnimation {
            amountText = ""
            titleText = ""
            noteText = ""
            opType = .expense
            selectedCategory = .other
        }
        amountFocused = true
    }
}

#Preview {
    PayView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
