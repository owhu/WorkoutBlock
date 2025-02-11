//
//  WorkoutPlannerView.swift
//  WorkoutBlock
//
//  Created by Oliver Hu on 2/11/25.
//

import SwiftUI

struct WorkoutPlannerView: View {
    @AppStorage("exercises") private var storedExercises: Data = Data()
    @AppStorage("weekDays") private var storedWeekDays: Data = Data()
    
    @State private var exercises: [Exercise] = []
    @State private var weekDays: [DaySlot] = [
        DaySlot(day: "Sun"), DaySlot(day: "Mon"), DaySlot(day: "Tue"),
        DaySlot(day: "Wed"), DaySlot(day: "Thu"), DaySlot(day: "Fri"),
        DaySlot(day: "Sat")
    ]
    
    @State private var draggedExercise: Exercise?
    @State private var newExerciseName = ""
    
    @State private var showingAddItem = false

    var body: some View {
        VStack {
            // Reset Button
            Button("Reset Week") {
                withAnimation {
                    weekDays = weekDays.map { DaySlot(day: $0.day) }
                    saveData()
                }
            }
            .padding()
            .background(Color.red.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)

            // Weekday Boxes
            ScrollView(.horizontal) {
                HStack {
                    ForEach(weekDays.indices, id: \.self) { index in
                        VStack {
                            Text(weekDays[index].day)
                                .font(.headline)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 150)
                                .overlay(
                                    VStack {
                                        ForEach(weekDays[index].exercises) { exercise in
                                            HStack {
                                                Text(exercise.name)
                                                    .padding(5)
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(5)
                                                Spacer()
                                                Button(action: {
                                                    removeExercise(from: index, exercise: exercise)
                                                }) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.red)
                                                }
                                            }
                                            .padding(.horizontal, 5)
                                        }
                                    }
                                )
                                .onDrop(of: [.plainText], isTargeted: nil) { providers in
                                    if let draggedExercise = draggedExercise {
                                        assignExercise(draggedExercise, to: index)
                                    }
                                    return true
                                }
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
            
            Button {
                showingAddItem = true
            } label: {
                Image(systemName: "plus")
                    .modifier(StandardButtonModifier())
            }
            .padding()
            
            .sheet(isPresented: $showingAddItem) {
                AddView()
            }

            // Add New Exercise Section
            HStack {
                TextField("New Exercise", text: $newExerciseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: addExercise) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()

            // Exercise List (Supports Deleting)
            List {
                ForEach(exercises) { exercise in
                    Text(exercise.name)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(5)
                        .onDrag {
                            draggedExercise = exercise
                            return NSItemProvider(object: exercise.name as NSString)
                        }
                }
                .onDelete(perform: deleteExercise)
            }
        }
        .onAppear(perform: loadData)
    }

    // Assigns an exercise to a day slot
    private func assignExercise(_ exercise: Exercise, to dayIndex: Int) {
        withAnimation {
            weekDays[dayIndex].exercises.append(exercise)
            saveData()
        }
    }

    // Removes an exercise from a day slot
    private func removeExercise(from dayIndex: Int, exercise: Exercise) {
        withAnimation {
            weekDays[dayIndex].exercises.removeAll { $0.id == exercise.id }
            saveData()
        }
    }

    // Adds a new exercise to the list
    private func addExercise() {
        let trimmedName = newExerciseName.trimmingCharacters(in: .whitespaces)
        if !trimmedName.isEmpty {
            withAnimation {
                exercises.append(Exercise(name: trimmedName))
                newExerciseName = "" // Clear text field
                saveData()
            }
        }
    }

    // Deletes an exercise from the list
    private func deleteExercise(at offsets: IndexSet) {
        withAnimation {
            exercises.remove(atOffsets: offsets)
            saveData()
        }
    }

    // Saves data to AppStorage
    private func saveData() {
        if let encodedExercises = try? JSONEncoder().encode(exercises) {
            storedExercises = encodedExercises
        }
        if let encodedWeekDays = try? JSONEncoder().encode(weekDays) {
            storedWeekDays = encodedWeekDays
        }
    }

    // Loads data from AppStorage
    private func loadData() {
        if let decodedExercises = try? JSONDecoder().decode([Exercise].self, from: storedExercises) {
            exercises = decodedExercises
        }
        if let decodedWeekDays = try? JSONDecoder().decode([DaySlot].self, from: storedWeekDays) {
            weekDays = decodedWeekDays
        }
    }
}






#Preview {
    WorkoutPlannerView()
}
