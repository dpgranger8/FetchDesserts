//
//  HomeVM.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

import SwiftUI

class HomeScreenVM: ObservableObject {
    static var shared = HomeScreenVM()
    @Published var meals: [Meal] = []
    var mealSelection: Meal?
    var error: String?
}
