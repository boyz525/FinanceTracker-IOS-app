//
//  HomeView.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//

import Foundation
import SwiftUI
import Charts


struct HomeView: View {
    var body: some View {
        ZStack{
            AnimatedBackground()
            
            VStack(){
                
                
                HStack(){
                    Text("Welcome back!")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                        .padding(.horizontal,20)
                        .padding(.top,9)
                    Spacer()
                }
                //.frame(width: 380, height: 400)
                .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 45))
                .padding(.top, 70)
                
                Spacer()
                
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
