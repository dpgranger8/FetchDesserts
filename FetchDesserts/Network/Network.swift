//
//  Network.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import Foundation
import UIKit

class Network {
    enum APIError: Error, LocalizedError {
        case invalidResponse
        case wasNot200
        
        public var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return NSLocalizedString("The server did not send a valid response", comment: "Invalid Response")
            case .wasNot200:
                return NSLocalizedString("The network request was unsuccessful", comment: "Error")
            }
        }
    }
    
    enum Endpoint: String {
        case allDesserts = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        case mealDetail = "https://themealdb.com/api/json/v1/1/lookup.php?i="
    }
    
    static let shared = Network()
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func getDesserts(completion: @escaping (Swift.Result<DessertsResponse, Error>) -> Void) async {
        var request = URLRequest(url: URL(string: Endpoint.allDesserts.rawValue)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                print(httpResponse.statusCode)
                throw APIError.wasNot200
            }
            
            let responseObject = try decoder.decode(DessertsResponse.self, from: data)
            completion(.success(responseObject))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func getMealDetail(id: String, completion: @escaping (Swift.Result<MealDetail, Error>) -> Void) async {
        var request = URLRequest(url: URL(string: Endpoint.mealDetail.rawValue + id)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                print(httpResponse.statusCode)
                throw APIError.wasNot200
            }
            
            let responseObject = try decoder.decode(MealDetailResponse.self, from: data)
            completion(.success(responseObject.meals[0]))
        } catch let error {
            completion(.failure(error))
        }
    }
}

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
