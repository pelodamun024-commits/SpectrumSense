// ContentView.swift

import SwiftUI

struct ContentView: View {
    // Создаем экземпляр нашего сервиса как StateObject,
    // чтобы он жил вместе с этим View.
    @StateObject private var cameraService = CameraService()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 80))
                .foregroundColor(AppColors.accent)
            
            Text("Уровень освещенности:")
                .font(.headline)
                .foregroundColor(AppColors.secondaryText)
            
            // Отображаем значение из cameraService
            Text(String(format: "%.0f люкс", cameraService.luxValue))
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.primaryText)
            
        }
        .padding()
        // Запускаем сессию, когда View появляется на экране
        .onAppear {
            cameraService.startSession()
        }
        // Останавливаем сессию, когда View исчезает
        .onDisappear {
            cameraService.stopSession()
        }
    }
}

#Preview {
    ContentView()
}
