// Core/Views/CameraPermissionView.swift

import SwiftUI

struct CameraPermissionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(AppColors.accent)
            
            Text("Camera Access Required")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText)
            
            Text("To measure light levels, please grant camera access in your device settings.")
                .font(.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: openAppSettings) {
                Text("Go to Settings")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColors.accent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 50)
        }
    }
    
    // Функция для открытия настроек приложения
    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}

#Preview {
    CameraPermissionView()
}
