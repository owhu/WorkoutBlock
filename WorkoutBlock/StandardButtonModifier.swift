//
//  StandardButtonModifier.swift
//  WorkoutBlock
//
//  Created by Oliver Hu on 2/11/25.
//

import SwiftUI

struct StandardButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
            .frame(width: 352, height: 44)
            .background(.thinMaterial)
            .cornerRadius(8)
    }
}
