//
//  MealItem.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import SwiftUI

struct MealItem: View {
    var meal: Meal
    var isPreview: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            CacheAsyncImage(url: URL(string: meal.strMealThumb + (isPreview ? "/preview" : ""))!, transaction: .init(animation: .default)) { phase in
                switch phase {
                case .failure:
                    TopHalf(isPreview: isPreview)
                        .foregroundStyle(Statics.specialGray)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .imageScale(.large)
                                .scaleEffect(1.5)
                        }
                case .success(let image):
                    image
                        .resizable()
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: (isPreview ? Statics.rectangleRadius : 0), bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: (isPreview ? Statics.rectangleRadius : 0)))
                default:
                    TopHalf(isPreview: isPreview)
                        .foregroundStyle(.gray)
                        .mask {
                            CustomLoad()
                                .scaleEffect(isPreview ? 0.5 : 1.5)
                        }
                }
            }
            .aspectRatio(contentMode: .fit)
            BottomBar
                .if(!isPreview) {$0.hidden()}
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

struct TopHalf: View {
    var isPreview: Bool
    
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: (isPreview ? Statics.rectangleRadius : 0), bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: (isPreview ? Statics.rectangleRadius : 0))
    }
}

#Preview {
    MealItem(meal: Statics.dummyMeal, isPreview: true)
}
