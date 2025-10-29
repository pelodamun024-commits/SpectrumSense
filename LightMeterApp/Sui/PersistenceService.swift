// Core/Services/PersistenceService.swift

import Foundation

class PersistenceService {
    
    private static let userDefaults = UserDefaults.standard
    private static let measurementsKey = "savedMeasurements"
    
    // Загружает все замеры из UserDefaults
    static func loadMeasurements() -> [Measurement] {
        guard let data = userDefaults.data(forKey: measurementsKey) else {
            return [] // Если данных нет, возвращаем пустой массив
        }
        
        do {
            let decoder = JSONDecoder()
            let measurements = try decoder.decode([Measurement].self, from: data)
            // Сортируем по дате, чтобы новые были сверху
            return measurements.sorted { $0.date > $1.date }
        } catch {
            print("Error decoding measurements: \(error)")
            return []
        }
    }
    
    // Сохраняет новый замер
    static func save(measurement: Measurement) {
        var allMeasurements = loadMeasurements()
        allMeasurements.append(measurement)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(allMeasurements)
            userDefaults.set(data, forKey: measurementsKey)
        } catch {
            print("Error encoding measurements: \(error)")
        }
    }
    
    static func saveAll(measurements: [Measurement]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(measurements)
            userDefaults.set(data, forKey: measurementsKey)
        } catch {
            print("Error encoding all measurements: \(error)")
        }
    }
    
    static func clearAllHistory() {
        userDefaults.removeObject(forKey: measurementsKey)
    }
}
