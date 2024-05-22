//
//  Network.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import Foundation
import UIKit

@Observable
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
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func getMealDetail(id: String, completion: @escaping (Swift.Result<MealDetail, Error>) -> Void) async {
        var request = URLRequest(url: URL(string: Endpoint.mealDetail.rawValue + id)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(id)
        
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
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
}

//chocolate gateau, bakewell, apple frangipan
