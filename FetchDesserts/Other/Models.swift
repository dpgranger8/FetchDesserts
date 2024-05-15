//
//  Models.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

import Foundation

struct DessertsResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable, Hashable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct MealDetailResponse: Codable {
    let meals: [MealDetail]
}

struct MealDetail: Codable {
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strYoutube: String
    let strIngredient1: String
    let strIngredient2: String
    let strIngredient3: String
    let strIngredient4: String
    let strIngredient5: String
    let strIngredient6: String
    let strIngredient7: String
    let strIngredient8: String
    let strIngredient9: String
    let strIngredient10: String
    let strIngredient11: String
    let strIngredient12: String
    let strIngredient13: String
    let strIngredient14: String
    let strIngredient15: String
    let strIngredient16: String
    let strIngredient17: String
    let strIngredient18: String
    let strIngredient19: String
    let strIngredient20: String
    let strMeasure1: String
    let strMeasure2: String
    let strMeasure3: String
    let strMeasure4: String
    let strMeasure5: String
    let strMeasure6: String
    let strMeasure7: String
    let strMeasure8: String
    let strMeasure9: String
    let strMeasure10: String
    let strMeasure11: String
    let strMeasure12: String
    let strMeasure13: String
    let strMeasure14: String
    let strMeasure15: String
    let strMeasure16: String
    let strMeasure17: String
    let strMeasure18: String
    let strMeasure19: String
    let strMeasure20: String
    let strSource: String
}

extension MealDetail {
    func ingredientsList() -> [String] {
        return propertiesList(prefix: "strIngredient")
    }
    
    func measuresList() -> [String] {
        return propertiesList(prefix: "strMeasure")
    }
    
    private func propertiesList(prefix: String) -> [String] {
        let mirror = Mirror(reflecting: self)
        // Filter properties by prefix and ensure they're non-empty strings
        let filteredProperties = mirror.children.compactMap { (label: String?, value: Any) -> String? in
            guard let label = label, label.hasPrefix(prefix), let value = value as? String, !value.trimmingCharacters(in: .whitespaces).isEmpty else {
                return nil
            }
            return value
        }
        
        return filteredProperties
    }
    
    //zip pairs array for easy use
    func ingredientsAndMeasures() -> [IngredientPair] {
        let ingredients = ingredientsList()
        let measures = measuresList()
        
        let pairedList = zip(ingredients, measures).map { IngredientPair(ingredient: $0, measure: $1) }
        return pairedList
    }
}

struct IngredientPair: Identifiable, Equatable {
    var id: String { ingredient }
    let ingredient: String
    let measure: String
}
