//
//  MealDetailScrollContent.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

import SwiftUI

struct MealDetailScrollContent: View {
    var meal: Meal
    
    @State var vm = MealDetailVM()
    let spacing: CGFloat = 20
    
    var body: some View {
        VStack {
            if let errorMessage = vm.error {
                UnavailableView(message: errorMessage) {
                    Task {
                        await getMealDetail()
                    }
                }
            } else {
                
            }
        }
        .task {
            await getMealDetail()
        }
        .padding(.top, spacing)
    }
    
    
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
}

#Preview {
    MealDetailScrollContent(meal: Meal(strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg", idMeal: "52893"))
}
