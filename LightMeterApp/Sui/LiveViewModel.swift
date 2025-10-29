// Core/ViewModels/LiveViewModel.swift

import Foundation
import Combine

class LiveViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var luxValue: Double = 0.0
    @Published var recommendation: String = "Point the camera at the light source"
    @Published var isPermissionGranted: Bool = false
    // MARK: - Private Properties
    
    private let cameraService: CameraService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(cameraService: CameraService) {
        self.cameraService = cameraService
        setupSubscribers()
    }
    
    // MARK: - Public Methods
    
    func start() {
        cameraService.startSession()
    }
    
    func stop() {
        cameraService.stopSession()
    }
    
    // MARK: - Private Methods
    
    private func setupSubscribers() {
        // Подписываемся на изменения luxValue в CameraService
        cameraService.$luxValue
            .receive(on: DispatchQueue.main) // Убеждаемся, что обновления приходят в главный поток
            .sink { [weak self] newLuxValue in
                self?.luxValue = newLuxValue
                self?.updateRecommendation(for: newLuxValue)
            }
            .store(in: &cancellables)
        
        cameraService.$permissionStatus
                    .receive(on: DispatchQueue.main)
                    .map { status -> Bool in
                        return status == .authorized
                    }
                    .assign(to: \.isPermissionGranted, on: self)
                    .store(in: &cancellables)
    }
    
    private func updateRecommendation(for lux: Double) {
        switch lux {
        case 0...20:
            recommendation = "Very dark. Not suitable for most activities."
        case 21...100:
            recommendation = "Dim lighting. Suitable for rest and relaxation."
        case 101...300:
            recommendation = "Soft light. Perfect for watching TV or cozy evenings."
        case 301...750:
            recommendation = "Excellent lighting! Perfect for reading and working at your desk."
        case 751...1500:
            recommendation = "Very bright light. Suitable for tasks requiring attention to detail."
        default:
            recommendation = "The intensity of light is comparable to a clear day outside."
        }
    }
    
    func saveCurrentMeasurement(note: String) {
        let newMeasurement = Measurement(luxValue: self.luxValue, note: note)
        PersistenceService.save(measurement: newMeasurement)
    }
}
