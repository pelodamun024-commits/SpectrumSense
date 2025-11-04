// Core/Views/LiveView.swift

import SwiftUI

struct LiveView: View {
    
    // <-- ВОЗВРАЩАЕМ @StateObject. View владеет своей ViewModel.
    @StateObject private var viewModel: LiveViewModel
    
    // Инициализатор, который мы добавили, остается правильным.
    // Он позволяет передать зависимость (cameraService) в ViewModel при ее создании.
    init(cameraService: CameraService) {
        _viewModel = StateObject(wrappedValue: LiveViewModel(cameraService: cameraService))
    }

    @State private var isShowingSaveSheet = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            if viewModel.isPermissionGranted {
                VStack(spacing: 16) {
                    Spacer()
                    
                    VStack {
                        Text(String(format: "%.0f", viewModel.luxValue))
                            .font(.system(size: 96, weight: .heavy, design: .rounded))
                            .foregroundColor(AppColors.primaryText)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        Text("lux")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.secondaryText)
                            .offset(y: -10)
                    }
                    
                    Text(viewModel.recommendation)
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(height: 80)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingSaveSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.accent)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 30)
                }
                .padding()
            } else {
                CameraPermissionView()
            }
        }

        .sheet(isPresented: $isShowingSaveSheet) {
            if #available(iOS 15.0, *) {
                SaveMeasurementView(luxValue: viewModel.luxValue) { note in
                    viewModel.saveCurrentMeasurement(note: note)
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
