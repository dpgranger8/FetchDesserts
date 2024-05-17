//
//  ViewModifiers.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import SwiftUI
import Combine

public extension View {
    // Conditional view modifier that toggles view modifiers on or off as needed
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
    
    // Limits text field input length. used for search bar
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

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

struct SignPainterFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SignPainter", size: 60).bold())
    }
}

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        if #available(iOS 14, *) {
            content
                .onChange(of: $value.wrappedValue) { oldValue, newValue in
                    value = String(newValue.prefix(length))
                }
        } else {
            content
                .onReceive(Just(value)) {
                    value = String($0.prefix(length))
                }
        }
    }
}
