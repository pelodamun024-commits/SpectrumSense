// Core/Views/SettingsView.swift

import SwiftUI
import StoreKit // <-- 1. Импортируем StoreKit для функции оценки

@available(iOS 15.0, *)
struct SettingsView: View {
    // Получаем доступ к текущей сцене, чтобы показать окно оценки
    //@Environment(\.windowScene) var windowScene
    
    @State private var showingClearHistoryAlert = false
    
    // --> 2. URL вашего приложения в App Store.
    // !!! ВАЖНО: Замените "your-app-id-here" на ID вашего приложения после публикации.
    private let appURL = URL(string: "https://apps.apple.com/app/your-app-id-here")!
    
    // --> 3. Динамически получаем версию приложения из build settings
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                if #available(iOS 16.0, *) {
                    Form {
                        // --> 4. Новый раздел для вовлечения пользователей
                        Section(header: Text("Support & Feedback")) {
                            Button(action: rateTheApp) {
                                Label("Rate The App", systemImage: "star.fill")
                            }
                            
                            // ShareLink - нативный способ поделиться контентом
                            ShareLink(item: appURL) {
                                Label("Share The App", systemImage: "square.and.arrow.up")
                            }
                        }
                        .foregroundColor(AppColors.primaryText) // Делаем текст кнопок основным цветом
                        
                        Section(
                            header: Text("Data Management"),
                            footer: Text("This action cannot be undone.")
                        ) {
                            Button("Clear History", role: .destructive) {
                                showingClearHistoryAlert = true
                            }
                        }
                        
                        Section(header: Text("About")) {
                            HStack {
                                Text("App Version")
                                Spacer()
                                Text(appVersion) // Используем динамическую версию
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    // Fallback on earlier versions
                }
            }
            .navigationTitle("Settings")
            .alert("Are you sure?", isPresented: $showingClearHistoryAlert) {
                Button("Clear All", role: .destructive, action: PersistenceService.clearAllHistory)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("All your saved measurements will be permanently deleted.")
            }
        }
    }
    
    func rateTheApp() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
