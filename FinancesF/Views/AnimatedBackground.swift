//
//  AnimatedBackground.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//


import SwiftUI
import Combine

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
