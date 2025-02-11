//
//  AddView.swift
//  WorkoutBlock
//
//  Created by Oliver Hu on 2/11/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var checked = false
    
    @FocusState private var nameFieldIsFocused: Bool

    

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                    .focused($nameFieldIsFocused)
            }
            .navigationTitle("Add new item")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = Item(title: title, isChecked: false, dateAdded: Date.now)
                        modelContext.insert(item)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                    nameFieldIsFocused = true
            }
            .onSubmit {
                let item = Item(title: title, isChecked: false, dateAdded: Date.now)
                modelContext.insert(item)
                dismiss()
            }
        }

    }
}

#Preview {
    AddView()
}
