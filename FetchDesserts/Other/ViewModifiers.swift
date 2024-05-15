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

/// From https://stackoverflow.com/a/64495887
struct DidLoadViewModifier: ViewModifier {
    
    @State private var didLoad = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
    
}

extension View {
    
    /// Adds an action to perform when this view is loaded.
    /// Called only once, unlike `onAppear`. Replacement for `viewDidLoad` from UIKit.
    ///
    /// - Parameter action: The action to perform. If `action` is `nil`, the
    ///   call has no effect.
    ///
    /// - Returns: A view that triggers `action` when this view appears.
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(DidLoadViewModifier(perform: action))
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
    
    func headerStyle() -> some View {
        self.modifier(HeaderMod())
    }
}

struct HeaderMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title.bold())
            .padding(.bottom, 10)
    }
}
