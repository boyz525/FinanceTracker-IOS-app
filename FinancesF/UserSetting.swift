//
//  UserDefaultSetting.swift
//  FinancesF
//
//  Created by Александр Малахов on 01.04.2026.
//


import Foundation

@Observable
final class UserSettings {
    
    private enum Keys {
        static let userName = "user_name"
    }
    
    private(set) var userName: String?
    
    init() {
        userName = UserDefaults.standard.string(forKey: Keys.userName)
    }
    
    var isOnboardingComplete: Bool {
        guard let name = userName else { return false }
        return !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func saveUserName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        UserDefaults.standard.set(trimmed, forKey: Keys.userName)
        userName = trimmed
    }
    
    func reset() {
        UserDefaults.standard.removeObject(forKey: Keys.userName)
        userName = nil
    }
}
