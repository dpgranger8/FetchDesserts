//
//  ViewModifiers.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import SwiftUI

// Preference Key used for alphabet sidebar
struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

// Conditional view modifier that toggles view modifiers on or off as needed
public extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func signPainter() -> some View {
        self.modifier(SignPainterFont())
    }
}

struct SignPainterFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SignPainter", size: 60).bold())
    }
}
