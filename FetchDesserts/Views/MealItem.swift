//
//  MealItem.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import SwiftUI

struct MealItem: View {
    @Environment(\.colorScheme) var colorScheme
    @State var url: URL?
    var meal: Meal
    
    var body: some View {
        CacheAsyncImage(url: URL(string: meal.strMealThumb + "/preview")!, transaction: .init(animation: .default)) { phase in
            switch phase {
            case .failure:
                Placeholder {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .imageScale(.large)
                        .scaleEffect(1.5)
                }
            case .success(let image):
                image
                    .resizable()
                    .clipShape(.rect(cornerRadius: Statics.rectangleRadius))
            default:
                Placeholder {
                    ProgressView()
                }
            }
        }
        .aspectRatio(contentMode: .fit)
        .overlay(alignment: .bottom) {
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: Statics.rectangleRadius, bottomTrailingRadius: Statics.rectangleRadius, topTrailingRadius: 0)
                    .foregroundStyle(.thinMaterial)
                    .frame(height: 50)
                Text(meal.strMeal)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .scaledToFit()
                    .minimumScaleFactor(0.7)
            }
            .offset(y: 10)
        }
    }
}

struct Placeholder<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        RoundedRectangle(cornerRadius: Statics.rectangleRadius)
            .foregroundStyle(Statics.halfGray)
            .overlay {
                content
            }
    }
}
