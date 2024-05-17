//
//  CustomLoad.swift
//  FetchDesserts
//
//  Created by David Granger on 5/16/24.
//

import SwiftUI

struct CustomLoad: View {
    @State var animate: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            // Using foreach here was breaking the animation
            LoadGradient
                .offset(x: animate)
            LoadGradient
                .offset(x: animate)
            LoadGradient
                .offset(x: animate)
        }
        .offset(x: -500)
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                animate += 500
            }
        }
    }
    
    @ViewBuilder
    private var LoadGradient: some View {
        LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.5), .gray.opacity(0.7), .gray.opacity(0.5), .gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
            .frame(width: 500, height: 500)
    }
}

#Preview {
    CustomLoad()
}
