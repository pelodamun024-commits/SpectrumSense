// Core/Models/OnboardingStep.swift

import Foundation

struct OnboardingStep: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}


import SwiftUI

struct OnboardingStepView: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.1))
                    .frame(width: 250, height: 250)
                
                Image(systemName: step.imageName)
                    .font(.system(size: 100, weight: .light))
                    .foregroundColor(AppColors.accent)
            }
            
            Text(step.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)

            Text(step.description)
                .font(.headline)
                .fontWeight(.regular)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding()
    }
}




struct OnboardingView: View {
    // Binding для закрытия модального окна
    @Binding var isPresented: Bool
    
    // Данные для наших экранов
    private let steps: [OnboardingStep] = [
        OnboardingStep(imageName: "camera.metering.center.weighted",
                       title: "Instant Light Reading",
                       description: "Get precise light level (lux) measurements in real-time using your camera."),
        OnboardingStep(imageName: "swatchpalette.fill",
                       title: "Understand Your Light",
                       description: "Analyze the color temperature to know if the light is warm, neutral, or cool."),
        OnboardingStep(imageName: "text.book.closed.fill",
                       title: "Track Your History",
                       description: "Save your measurements with notes and track how the light changes over time.")
    ]
    
    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack {
                // Кнопка "Пропустить"
                HStack {
                    Spacer()
                    Button("Skip") {
                        dismissOnboarding()
                    }
                    .padding()
                    .foregroundColor(AppColors.accent)
                }
                
                Spacer()
                
                // Свайпаемые страницы
                TabView(selection: $currentStep) {
                    ForEach(steps.indices, id: \.self) { index in
                        OnboardingStepView(step: steps[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                Spacer()
                
                // Кнопка "Далее" / "Начать"
                Button(action: nextStep) {
                    Text(currentStep == steps.count - 1 ? "Get Started" : "Continue")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.accent)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(30)
            }
        }
    }
    
    private func nextStep() {
        if currentStep < steps.count - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            dismissOnboarding()
        }
    }
    
    private func dismissOnboarding() {
        // Запоминаем, что онбординг пройден
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        isPresented = false
    }
}
