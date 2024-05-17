//
//  Home.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

// I am aware that my app may not be optimized for landscape mode or viewing on all screen sizes such as iPad due to the way my detail view has been architected

import SwiftUI

struct Home: View {
    // UI Coordinator for zoom animation
    var coordinator: UICoordinator = .init()
    
    //MARK: Properties
    @StateObject var vm = HomeScreenVM.shared
    @StateObject var searchVM = SearchViewModel.shared
    let alphabet = (97...122).map({String(UnicodeScalar($0))})
    let spacing: CGFloat = 20
    
    //MARK: UI
    var body: some View {
        Group {
            if let errorMessage = vm.error {
                UnavailableView(message: errorMessage) {
                    Task {
                        await getDesserts()
                    }
                }
            } else {
                VStack(spacing: 0) {
                    MainContent
                    if searchVM.viewState != .loading {
                        SearchBar(text: $searchVM.searchTerm)
                    }
                }
                .animation(.default, value: searchVM.viewState)
                .opacity(coordinator.hideRootView ? 0 : 1)
                .allowsHitTesting(!coordinator.hideRootView)
                .overlay {
                    Detail()
                        .environment(coordinator)
                        .allowsHitTesting(coordinator.hideLayer)
                }
                .background(.background)
            }
        }
        .task {
            await getDesserts()
        }
    }
    
    //MARK: Functions
    func getDesserts() async {
        await Network.shared.getDesserts(completion: { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    withAnimation {
                        vm.meals = response.meals.sorted { meal1, meal2 in
                            meal1.strMeal < meal2.strMeal //sort desserts by alphabetical order
                        }.filter { meal in
                            meal.strMeal != "" || meal.idMeal != "" //filter out any possible empty values
                        }
                        searchVM.onAppear()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    withAnimation {
                        vm.error = error.localizedDescription
                    }
                }
            }
        })
    }
    
    //MARK: Subviews
    @ViewBuilder
    private var MainContent: some View {
        switch searchVM.viewState {
        case .loading:
            EmptyView()
            
        case .loaded(let items):
            AlphabetSidebarViewWithDrag(listView: ScrollView {
                Text("Dave's Desserts")
                    .signPainter()
                    .padding(.top, spacing)
                ItemGrid(searchResults: items)
                    .padding([.vertical, .bottom], spacing)
                    .background(ScrollViewExtractor {
                        coordinator.scrollView = $0
                    })
                
                //TODO: sometimes dragging on the alphabet sidebar while images are loading causes an image load failure
            }.scrollIndicators(.hidden).scrollDismissesKeyboard(.immediately), lookup: { letter in
                items.first { $0.strMeal.prefix(1).lowercased() == letter }
            }, alphabetFiltered: alphabet.filter { letter in
                items.contains { $0.strMeal.prefix(1).lowercased() == letter }
            })
            .scrollDisabled(coordinator.hideRootView)
            
        case .empty:
            VStack(spacing: 0) {
                Text("No search results found")
                    .multilineTextAlignment(.center)
                    .frame(maxHeight: .infinity)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    func ItemGrid(searchResults: [Meal]) -> some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 150, maximum: 160), spacing: spacing),
            GridItem(.adaptive(minimum: 150, maximum: 160), spacing: spacing)
        ], alignment: .center, spacing: spacing) {
            ForEach(searchResults, id: \.self) { meal in
                CardView(meal)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func CardView(_ meal: Meal) -> some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            Button {
                coordinator.toggleView(show: true, frame: frame, meal: meal)
            } label: {
                MealItem(meal: meal, isPreview: true)
            }
        }
        .frame(height: 220)
    }
}
