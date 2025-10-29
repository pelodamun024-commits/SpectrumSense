// Core/ViewModels/HistoryViewModel.swift

import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    
    @Published var measurements: [Measurement] = []
    
    init() {
        loadMeasurements()
    }
    
    func loadMeasurements() {
        self.measurements = PersistenceService.loadMeasurements()
    }
    
    func deleteMeasurement(at offsets: IndexSet) {
        // Получаем все замеры
        var allMeasurements = PersistenceService.loadMeasurements()
        
        // Удаляем нужные элементы из массива
        allMeasurements.remove(atOffsets: offsets)
        
        // Пересохраняем обновленный массив.
        // Для этого нам нужно добавить метод в PersistenceService.
        PersistenceService.saveAll(measurements: allMeasurements)
        
        // Обновляем наш опубликованный массив, чтобы UI перерисовался
        self.measurements = allMeasurements
    }
}
