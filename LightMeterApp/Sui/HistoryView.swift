// Core/Views/HistoryView.swift

import SwiftUI

struct HistoryView: View {
    
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                if viewModel.measurements.isEmpty {
                    // Показываем заглушку, если история пуста
                    emptyStateView
                } else {
                    // Показываем список замеров
                    List {
                        ForEach(viewModel.measurements) { measurement in
                            MeasurementRow(measurement: measurement)
                        }
                        .onDelete(perform: viewModel.deleteMeasurement)
                        .listRowBackground(AppColors.element)
                    }
                    .listStyle(.plain) // Убираем стандартный стиль списка
                    .background(AppColors.background)
                    .scrollContentBackground(.hidden) // Делает фон списка прозрачным
                }
            }
            .navigationTitle("History")
            .onAppear {
                // Обновляем данные каждый раз, когда экран появляется
                viewModel.loadMeasurements()
            }
        }
    }
    
    // Вспомогательное View для пустого состояния
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            Text("No History Yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText)
            Text("Your saved measurements will appear here.")
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}


// Отдельное View для строки списка, чтобы не загромождать основной код
struct MeasurementRow: View {
    
    let measurement: Measurement
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(measurement.note)
                    .font(.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text(measurement.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text("\(String(format: "%.0f", measurement.luxValue)) lux")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.accent)
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    HistoryView()
}
