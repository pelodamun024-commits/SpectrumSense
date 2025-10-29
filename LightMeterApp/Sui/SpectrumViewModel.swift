// Core/ViewModels/SpectrumViewModel.swift

import Foundation
import Combine
import UIKit
import SwiftUI

class SpectrumViewModel: ObservableObject {
    
    @Published var detectedColor: UIColor = .systemGray
    @Published var colorTemperatureDescription: String = "Analyzing..."
    @Published var isPermissionGranted: Bool = false

    
    private let cameraService: CameraService
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraService: CameraService) {
        self.cameraService = cameraService
        setupSubscribers()
    }
    
    func start() {
        cameraService.startSession()
    }
    
    func stop() {
        cameraService.stopSession()
    }
    
    private func setupSubscribers() {
        cameraService.$averageColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] color in
                self?.detectedColor = color
                self?.updateDescription(for: color)
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
    
    private func updateDescription(for color: UIColor) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        
        // Простая логика определения "теплоты"
        // Красный/оранжевый/желтый = теплый
        if hue < 0.15 { // 0.0 - красный, 0.16 - желтый
            colorTemperatureDescription = "Warm Light"
        }
        // Синий/голубой = холодный
        else if hue > 0.5 && hue < 0.7 { // 0.5 - голубой, 0.66 - синий
            colorTemperatureDescription = "Cool Light"
        }
        // Все остальное + низкая насыщенность = нейтральный
        else if saturation < 0.25 {
            colorTemperatureDescription = "Neutral Light"
        } else {
             colorTemperatureDescription = "Neutral Light"
        }
    }
}
