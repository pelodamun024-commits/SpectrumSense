//
//  AppColors.swift
//  LightMeterApp
//
//  Created by D K on 24.10.2025.
//


import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct AppColors {
    // Основная палитра
    static let background = Color(hex: "#F5F7FA") // Очень светлый, почти белый
    static let element = Color(hex: "#FFFFFF")     // Белый для карточек
    static let accent = Color(hex: "#5EAAA8")      // Приглушенный бирюзовый
    
    // Текст
    static let primaryText = Color(hex: "#2C3E50") // Темно-сине-серый
    static let secondaryText = Color(hex: "#8D99AE") // Спокойный серо-голубой
    
    // Цвета для индикации света
    static let warm = Color(hex: "#FFCB8E") // Теплый оранжевый
    static let neutral = Color(hex: "#F5F5F5") // Нейтральный светлый
    static let cool = Color(hex: "#CDE8F5") // Холодный голубой
}
