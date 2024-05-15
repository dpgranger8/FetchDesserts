//
//  HomeVM.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

import SwiftUI

@Observable
class HomeScreenVM {
    var meals: [Meal] = []
    var mealSelection: Meal?
    var error: String?
    
    func resetValues() {
        meals = []
        mealSelection = nil
        error = nil
    }
}
