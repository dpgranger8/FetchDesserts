//
//  MealItem.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import SwiftUI

struct MealItem: View {
    var meal: Meal
    
    var body: some View {
        VStack(spacing: 2) {
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
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: Statics.rectangleRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: Statics.rectangleRadius))
                default:
                    Placeholder {
                        ProgressView()
                    }
                }
            }
            .aspectRatio(contentMode: .fit)
            BottomBar
        }
    }
    
    @ViewBuilder
    private var BottomBar: some View {
        ZStack {
            UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: Statics.rectangleRadius, bottomTrailingRadius: Statics.rectangleRadius, topTrailingRadius: 0)
                .foregroundStyle(.blue.gradient)
                .frame(height: 50)
            Text(meal.strMeal)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .scaledToFit()
                .minimumScaleFactor(0.7)
        }
    }
}

struct Placeholder<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: Statics.rectangleRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: Statics.rectangleRadius)
            .foregroundStyle(Statics.halfGray)
            .overlay {
                content
            }
    }
}
