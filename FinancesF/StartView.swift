//
//  ContentView.swift
//  FinancesF
//
//  Created by Александр Малахов on 31.03.2026.
//

import Foundation
import SwiftUI
internal import Combine

struct StartScreen: View {
    @State private var text = ""
    @State private var step: Int = 0
    // step 0 — начальный экран
    // step 1 — второй текст
    // step 2 — переход на HomeScreen
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if step == 2 {
                HomeScreen()
                    .transition(.opacity)
            } else {
                VStack {
                    Spacer()
                    
                    // Верхний VStack — уезжает вверх
                    if step == 0 {
                        VStack(alignment: .leading) {
                            Text("""
                        Привет,
                        давай знакомиться!
                        """)
                            .foregroundStyle(Color.white.opacity(0.8))
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.top, 40)
                            
                            Text("""
                        Напиши как тебя зовут.
                        """)
                            .foregroundStyle(Color.white.opacity(0.8))
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.top, 1)
                            .padding(.bottom, 40)
                        }
                        .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 90)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Второй VStack — появляется когда step == 1
                    if step == 1 {
                        VStack(alignment: .leading) {
                            Text("Отлично, \(UserSettings.userName)!")
                                .foregroundStyle(Color.white.opacity(0.8))
                                .font(.title)
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.top, 40)
                            
                            Text("Добро пожаловать\nв твои финансы.")
                                .foregroundStyle(Color.white.opacity(0.8))
                                .font(.title)
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.top, 1)
                                .padding(.bottom, 40)
                        }
                        .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 90)
                        .transition(.opacity)
                        .onAppear {
                            // через 2 секунды переходим на HomeScreen
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeInOut(duration: 0.8)) {
                                    step = 2
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // TextField и кнопка — растворяются
                    if step == 0 {
                        VStack(alignment: .center) {
                            TextField("Введи своё имя!", text: $text)
                                .foregroundStyle(Color.white.opacity(0.8))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                                .glassEffect(.clear.tint(.gray.opacity(0.15)).interactive(), in: RoundedRectangle(cornerRadius: 20))
                                .padding(.horizontal, 20)
                                .padding(.bottom, 130)
                            
                            Button("Далее") {
                                guard !text.isEmpty else { return }
                                UserSettings.userName = text
                                
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    step = 1
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 40)
                            .foregroundStyle(Color.white.opacity(0.8))
                            .glassEffect(.clear.tint(.blue.opacity(0.9)).interactive(), in: RoundedRectangle(cornerRadius: 20))
                            .font(.title)
                            .bold()
                            .padding(.bottom, 50)
                        }
                        .transition(.opacity)
                    }
                }
            }
        }
    }
}

struct AnimatedBackground: View {
    
    @State private var t: Float = 0
    
    var body: some View {
        MeshGradient(
            width: 4, height: 4,
            points: [
                [0.0, 0.0],
                [0.33 + sin(t * 0.3) * 0.03, 0.0],
                [0.67 + cos(t * 0.35) * 0.03, 0.0],
                [1.0, 0.0],
                
                [0.0, 0.33 + sin(t * 0.4) * 0.04],
                [sin(t * 0.5) * 0.3 + 0.4, cos(t * 0.4) * 0.3 + 0.4],
                [cos(t * 0.45 + 1.0) * 0.3 + 0.6, sin(t * 0.5 + 2.0) * 0.3 + 0.4],
                [1.0, 0.33 + cos(t * 0.35) * 0.04],
                
                [0.0, 0.67 + cos(t * 0.3) * 0.04],
                [sin(t * 0.4 + 3.0) * 0.25 + 0.35, cos(t * 0.35 + 1.5) * 0.25 + 0.6],
                [cos(t * 0.45 + 2.0) * 0.25 + 0.65, sin(t * 0.5 + 3.0) * 0.25 + 0.6],
                [1.0, 0.67 + sin(t * 0.4 + 1.0) * 0.04],
                
                [0.0, 1.0],
                [0.33 + cos(t * 0.25) * 0.03, 1.0],
                [0.67 + sin(t * 0.3) * 0.03, 1.0],
                [1.0, 1.0]
            ],
            colors: [
                Color(red: 0.04, green: 0.02, blue: 0.12),
                Color(red: 0.08, green: 0.04, blue: 0.18),
                Color(red: 0.10, green: 0.03, blue: 0.16),
                Color(red: 0.04, green: 0.02, blue: 0.10),
                
                Color(red: 0.06, green: 0.03, blue: 0.16),
                Color(red: 0.40, green: 0.08, blue: 0.52),
                Color(red: 0.14, green: 0.18, blue: 0.55),
                Color(red: 0.05, green: 0.03, blue: 0.14),
                
                Color(red: 0.05, green: 0.02, blue: 0.14),
                Color(red: 0.20, green: 0.08, blue: 0.45),
                Color(red: 0.45, green: 0.10, blue: 0.35),
                Color(red: 0.04, green: 0.02, blue: 0.12),
                
                Color(red: 0.03, green: 0.01, blue: 0.08),
                Color(red: 0.06, green: 0.03, blue: 0.14),
                Color(red: 0.05, green: 0.02, blue: 0.12),
                Color(red: 0.02, green: 0.01, blue: 0.06)
            ]
        )
        .ignoresSafeArea()
        .onReceive(
            Timer.publish(every: 1/30, on: .main, in: .common).autoconnect()
        ) { _ in
            t += 0.008
        }
    }
}


#Preview {
    StartScreen()
}

