//
//  Exercise.swift
//  WorkoutBlock
//
//  Created by Oliver Hu on 2/11/25.
//

import SwiftUI

struct Exercise: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
}

struct DaySlot: Identifiable, Codable {
    var id = UUID()
    var day: String
    var exercises: [Exercise] = []
}
