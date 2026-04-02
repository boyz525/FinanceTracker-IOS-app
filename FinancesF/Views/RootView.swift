//
//  RootView.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//

import SwiftUI

struct RootView: View {
    
    @Environment(UserSettings.self) private var settings
    
    var body: some View {
        if settings.isOnboardingComplete {
            MainView()
        } else {
            StartView()
        }
    }
}
