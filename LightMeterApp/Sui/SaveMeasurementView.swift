// Core/Views/SaveMeasurementView.swift

import SwiftUI

@available(iOS 15.0, *)
struct SaveMeasurementView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var note: String = ""
    
    let luxValue: Double
    let onSave: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Reading")) {
                    Text("\(String(format: "%.0f", luxValue)) lux")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Section(header: Text("Add a Note (Optional)")) {
                    TextField("e.g., 'Desk lamp in the evening'", text: $note)
                }
            }
            .navigationTitle("Save Measurement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if #available(iOS 16.0, *) {
                        Button("Save") {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            onSave(note.isEmpty ? "No note" : note)
                            dismiss()
                        }
                        .fontWeight(.bold)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }
}
