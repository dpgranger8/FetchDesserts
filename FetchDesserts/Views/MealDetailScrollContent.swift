//
//  MealDetailScrollContent.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

import SwiftUI

struct MealDetailScrollContent: View {
    //MARK: Properties
    @Environment(\.colorScheme) var colorScheme
    var meal: Meal
    @State var vm = MealDetailVM()
    let spacing: CGFloat = 15
    var specialBackground: Color {
        colorScheme == .dark ? Statics.backgroundGray : Color(uiColor: .systemGroupedBackground)
    }
    let lightBlue: Color = .blue.opacity(0.2)
    
    //MARK: UI
    var body: some View {
        VStack {
            if let errorMessage = vm.error {
                UnavailableView(message: errorMessage) {
                    Task {
                        await getMealDetail()
                    }
                }
            } else {
                LazyVStack(alignment: .leading) {
                    TitleHeader
                        .padding(.bottom, spacing / 2)
                    Group {
                        RecipeTable
                        Instructions
                    }
                    .padding(.horizontal, spacing)
                }
                .padding(.bottom, spacing * 4)
            }
        }
        .background(specialBackground)
        .task {
            await getMealDetail()
        }
    }
    
    //MARK: Functions
    func getMealDetail() async {
        vm.error = nil
        await Network.shared.getMealDetail(id: meal.idMeal, completion: { result in
            switch result {
            case .success(let response):
                withAnimation {
                    vm.mealDetail = response
                }
            case .failure(let error):
                withAnimation {
                    vm.error = error.localizedDescription
                }
            }
        })
    }
    
    //MARK: Subviews
    @ViewBuilder
    private var TitleHeader: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.blue.gradient)
            Text(meal.strMeal)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding([.horizontal, .vertical], spacing)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    func Header(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.headline)
            .fontWeight(.heavy)
            .padding(.bottom, 10)
            .padding(.top, 15)
    }
    
    @ViewBuilder
    private var Instructions: some View {
        if let instructions = vm.mealDetail?.strInstructions {
            Header("Directions")
            Text(instructions)
        }
    }
    
    @ViewBuilder
    private var RecipeTable: some View {
        if let items = vm.mealDetail?.ingredientsAndMeasures() {
            Header("Ingredients")
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Text("INGREDIENT")
                    Spacer()
                    Text("AMOUNT")
                }
                .padding(.bottom, 5)
                .font(.caption2)
                .fontWeight(.semibold)
                ForEach(items.indices, id: \.self) { index in
                    ZStack {
                        if index % 2 == 0 {
                            Rectangle()
                                .fill(lightBlue.gradient)
                                .padding(.horizontal, -15)
                        }
                        HStack {
                            Text(items[index].ingredient)
                            Spacer()
                            Text(items[index].measure)
                        }
                        .font(.subheadline)
                    }
                    .frame(height: 30)
                }
            }
            .padding(.horizontal, spacing)
            .padding(.vertical, spacing / 2)
            .background {
                RoundedRectangle(cornerRadius: Statics.rectangleRadius / 2)
                    .fill(.quinary)
            }
            .padding(.bottom, spacing / 2)
        }
    }
}

#Preview {
    MealDetailScrollContent(meal: Meal(strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg", idMeal: "52893"))
}
