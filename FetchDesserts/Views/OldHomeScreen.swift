//
//  HomeScreen.swift
//  FetchDesserts
//
//  Created by David Granger on 5/13/24.
//

import SwiftUI

@Observable
class HomeScreenVM {
    var meals: [Meal] = []
    var mealSelection: Meal?
    var error: String?
    
    func resetValues() {
        withAnimation {
            meals = []
            mealSelection = nil
            error = nil
        }
    }
}

struct HomeScreen: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SignPainter", size: 50)!]
    }
    
    @State var vm = HomeScreenVM()
    @State var isDetailPresented: Bool = false
    let alphabet = (97...122).map({String(UnicodeScalar($0))})
    let spacing: CGFloat = 20
    
    var body: some View {
        NavigationStack {
            Group {
                if let errorMessage = vm.error {
                    ContentUnavailableView(label: {
                        Label("Network Error", systemImage: "network.slash")
                    }, description: {
                        Text(errorMessage)
                    }, actions: {
                        Button {
                            Task {
                                await retryRequest()
                            }
                        } label: {
                            Text("Retry")
                        }
                    })
                } else {
                    AlphabetSidebarViewWithDrag(listView: ScrollView {
                        ItemGrid
                            .padding(.vertical, spacing)
                            .padding(.bottom, spacing)
                    }.scrollIndicators(.hidden), lookup: { letter in
                        vm.meals.first { $0.strMeal.prefix(1).lowercased() == letter }
                    }, alphabetFiltered: alphabet.filter { letter in
                        vm.meals.contains { $0.strMeal.prefix(1).lowercased() == letter }
                    })
                    //TODO: sometimes dragging on the alphabet sidebar while images are loading causes an image load failure
                }
            }
            .background(.gray.opacity(0.15))
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("David's Desserts")
            .navigationDestination(isPresented: $isDetailPresented) {
                VStack {
                    Text("Hello World")
                }
            }
            .refreshable {
                await retryRequest()
            }
        }
        .task {
            await getDesserts()
        }
    }
    
    func retryRequest() async {
        vm.resetValues()
        await getDesserts()
    }
    
    func getDesserts() async {
        vm.error = nil
        await Network.shared.getDesserts(completion: { result in
            switch result {
            case .success(let response):
                withAnimation {
                    vm.meals = response.meals.sorted { meal1, meal2 in
                        meal1.strMeal < meal2.strMeal //sort desserts by alphabetical order
                    }.filter { meal in
                        meal.strMeal != "" || meal.idMeal != "" //filter out any possible empty values
                    }
                }
            case .failure(let error):
                withAnimation {
                    vm.error = error.localizedDescription
                }
            }
        })
    }
    
    @ViewBuilder
    private var ItemGrid: some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 150, maximum: 160), spacing: spacing),
            GridItem(.adaptive(minimum: 150, maximum: 160), spacing: spacing)
        ], alignment: .center, spacing: spacing) {
            ForEach(vm.meals, id: \.self) { meal in
                Button {
                    isDetailPresented = true
                } label: {
                    MealItem(meal: meal, isPreview: true)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeScreen()
}
