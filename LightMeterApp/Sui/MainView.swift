// Core/Views/MainView.swift

import SwiftUI

struct MainView: View {
    
    
    @StateObject private var cameraService = CameraService()
    @State private var shouldShowOnboarding: Bool = false

    
    
    init() {
        // Настраиваем внешний вид TabBar
        // Это делается через UIKit Appearance, так как в SwiftUI пока нет полных возможностей кастомизации
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.element) // Цвет фона TabBar
        
        // Устанавливаем цвета для иконок и текста
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.secondaryText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(AppColors.secondaryText)]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.accent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(AppColors.accent)]
        
        // Применяем настройки
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            // Вкладка 1: Live
            LiveView(cameraService: cameraService)
                           .tabItem {
                               Label("Live", systemImage: "camera.metering.center.weighted")
                           }
            
            SpectrumView(cameraService: cameraService)
                            .tabItem {
                                Label("Spectrum", systemImage: "swatchpalette")
                            }
            
            // Вкладка 3: History
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            
            // Вкладка 4: Settings
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        // Устанавливаем цвет активной вкладки, который будет применен к иконке и тексту
        .accentColor(AppColors.accent)
        .onAppear(perform: checkOnboardingStatus)
               .fullScreenCover(isPresented: $shouldShowOnboarding) {
                   OnboardingView(isPresented: $shouldShowOnboarding)
               }
               .onAppear {
                           // Запускаем камеру, когда появляется главный экран
                           cameraService.startSession()
                       }
                       .onDisappear {
                           // Останавливаем камеру, когда главный экран исчезает
                           cameraService.stopSession()
                       }
    }
    
    
    private func checkOnboardingStatus() {
          // Если ключ "hasCompletedOnboarding" не найден или равен false, показываем онбординг
          if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
              shouldShowOnboarding = true
          }
      }
}

#Preview {
    MainView()
}
