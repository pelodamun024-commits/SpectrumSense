// Core/Views/SpectrumView.swift

import SwiftUI

struct SpectrumView: View {
    
    // <-- ВОЗВРАЩАЕМ @StateObject.
    @StateObject private var viewModel: SpectrumViewModel
    
    // Инициализатор также остается без изменений.
    init(cameraService: CameraService) {
        _viewModel = StateObject(wrappedValue: SpectrumViewModel(cameraService: cameraService))
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if viewModel.isPermissionGranted {
                VStack(spacing: 30) {
                    Text("Color Temperature")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primaryText)
                    
                    Circle()
                        .fill(Color(viewModel.detectedColor))
                        .frame(width: 250, height: 250)
                        .shadow(color: Color(viewModel.detectedColor).opacity(0.5), radius: 20, x: 0, y: 10)
                        .overlay(
                            Circle().stroke(AppColors.element, lineWidth: 10)
                        )
                    
                    Text(viewModel.colorTemperatureDescription)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.top, 50)
            } else {
                CameraPermissionView()
            }
        }
        
    }
}
