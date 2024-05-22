//
//  SearchViewModel.swift
//  BottomSearchBar
//
//  Created by Damjan Dabo on 11.04.23.
//

import Combine
import Foundation
import SwiftUI

struct SearchResult: Identifiable, Equatable {
    let id = UUID()
    let name: String
}

enum SearchViewState: Equatable {
    case loading
    case loaded(searchResults: [Meal])
    case empty
}

final class SearchViewModel: ObservableObject {
    
    // MARK: - Public properties
    @Published var searchTerm = ""
    @Published var viewState: SearchViewState = .loading
    @ObservedObject var homeVM: HomeScreenVM
    
    init(homeVM: HomeScreenVM) {
        self.homeVM = homeVM
    }
    
    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    func onAppear() {
        setupSearchBinding()
    }
    
    // MARK: - Private funcs
    
    private func setupSearchBinding() {
        let allMeals = homeVM.meals
        
        Publishers.Merge(
            $searchTerm.debounce(for: 0.3, scheduler: RunLoop.main),
            Just("") // Initial state
        )
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .removeDuplicates()
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .map { searchTerm -> [Meal] in
            guard searchTerm != "" else {
                return allMeals
            }
            
            return allMeals.filter { searchResult in
                return searchResult.strMeal.lowercased().contains(searchTerm.lowercased())
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] searchResults in
            guard let self else { return }
            
            guard !searchResults.isEmpty else {
                self.viewState = .empty
                return
            }
            
            self.viewState = .loaded(searchResults: searchResults)
        }
        .store(in: &cancellables)
    }
}
