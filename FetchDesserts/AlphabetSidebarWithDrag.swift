//
//  AlphabetSidebarWithDrag.swift
//  Storytime
//
//  Created by David Granger on 12/2/23.
//

import SwiftUI

struct AlphabetSidebarViewWithDrag<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @GestureState private var dragLocation: CGPoint = .zero
    
    var listView: Content
    var lookup: (String) -> (any Hashable)?
    var alphabetFiltered: [String]
//    var oppositeColorScheme: Color {
//        colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7)
//    }
    
    class IndexTitleState: ObservableObject {
        var currentTitleIndex = 0
        var titleSize: CGSize = CGSize(width: 8.0, height: 13.333333333333332) //This is the letter size, so change this if you change the static font size below
    }
    
    @StateObject var indexState = IndexTitleState()
    let impact = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack {
                listView
                alphabetSidebar(proxy: proxy)
            }
        }
    }
    
    private func alphabetSidebar(proxy: ScrollViewProxy) -> some View {
        HStack {
            Spacer()
            ZStack(alignment: .trailing) {
                VStack(spacing: 0) {
                    ForEach(alphabetFiltered, id: \.self) { letter in
                        Text(letter.uppercased())
                            .foregroundStyle(.blue)
                            .font(.caption) //set a letter size initialization value
                            .padding(.trailing, 3)
                            .modifier(SizeModifier())
                            .onPreferenceChange(SizePreferenceKey.self) {
                                self.indexState.titleSize = $0
                            }
                            .simultaneousGesture(TapGesture().onEnded({ _ in
                                impact.impactOccurred()
                                if let found = lookup(letter) {
                                    proxy.scrollTo(found, anchor: .top)
                                }
                            }))
                    }
                }
                .coordinateSpace(name: "VStackCoord")
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 22, height: self.indexState.titleSize.height * CGFloat(alphabetFiltered.count))
                    .opacity(0.001)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("VStackCoord"))
                            .updating($dragLocation) { value, state, _ in
                                state = value.location
                                scrollTo(location: state, proxy: proxy)
                            }
                    )
            }
        }
    }
    
    private func scrollTo(location: CGPoint, proxy: ScrollViewProxy) {
        if self.indexState.titleSize.height > 0 {
            let index = Int(location.y / self.indexState.titleSize.height)
            if index >= 0 && index < alphabetFiltered.count {
                if indexState.currentTitleIndex != index {
                    indexState.currentTitleIndex = index
                    DispatchQueue.main.async {
                        impact.impactOccurred()
                        let found = lookup(alphabetFiltered[indexState.currentTitleIndex])
                        if let f = found {
                            proxy.scrollTo(f, anchor: .top)
                        }
                    }
                }
            }
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

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
