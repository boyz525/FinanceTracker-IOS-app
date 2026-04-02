//
//  ContentView.swift
//  FinancesF
//
//  Created by Александр Малахов on 31.03.2026.
//

import SwiftUI

struct StartView: View {
    @State private var text = ""
    @Environment(UserSettings.self) private var settings
    var body: some View {
        ZStack{
            AnimatedBackground()
            VStack{
                
                Spacer()
                
                VStack(alignment: .leading){
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
                
                
                
                Spacer()
                
                VStack(alignment: .center){
                    TextField("Введи своё имя!", text: $text)
                        .foregroundStyle(Color.white.opacity(0.8))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .glassEffect(.clear.tint(.gray.opacity(0.15)).interactive(), in: RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 130)
                    Button("Далее"){
                        settings.saveUserName(text)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 40)
                    
                    .foregroundStyle(Color.white.opacity(0.8))
                    .glassEffect(.clear.tint(.blue.opacity(0.9)).interactive(), in: RoundedRectangle(cornerRadius: 20))
                    .font(.title)
                    .bold()
                    .padding(.bottom, 50)
                }
                
            }
            
        }
        
    }
    
}




#Preview {
    StartView()
        .environment(UserSettings())
}

