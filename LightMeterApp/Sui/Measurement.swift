// Core/Models/Measurement.swift

import Foundation

struct Measurement: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let luxValue: Double
    let note: String
    
    // Инициализатор по умолчанию для удобства
    init(id: UUID = UUID(), date: Date = Date(), luxValue: Double, note: String) {
        self.id = id
        self.date = date
        self.luxValue = luxValue
        self.note = note
    }
}
