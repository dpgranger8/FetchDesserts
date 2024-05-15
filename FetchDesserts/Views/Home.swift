//
//  Home.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

//I understand that my app may not be optimized for landscape mode or viewing on all screen sizes such as iPad due to the way my detail view has been architected.

import SwiftUI

struct Home: View {
    // UI Coordinator for zoom animation
    var coordinator: UICoordinator = .init()
    
    @State var vm = HomeScreenVM()
    let alphabet = (97...122).map({String(UnicodeScalar($0))})
    let spacing: CGFloat = 20
    
    var body: some View {
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
                    Text("David's Desserts")
                        .font(.custom("SignPainter", size: 50).bold())
                        .padding(.top, spacing)
                    ItemGrid
                        .padding(.vertical, spacing)
                        .padding(.bottom, spacing)
                        .background(ScrollViewExtractor {
                            coordinator.scrollView = $0
                        })
                    //TODO: sometimes dragging on the alphabet sidebar while images are loading causes an image load failure
                }.scrollIndicators(.hidden), lookup: { letter in
                    vm.meals.first { $0.strMeal.prefix(1).lowercased() == letter }
                }, alphabetFiltered: alphabet.filter { letter in
                    vm.meals.contains { $0.strMeal.prefix(1).lowercased() == letter }
                })
                //MARK: Start of code written by Balaji Venkatesh for smooth detail zoom animation https://www.youtube.com/watch?v=fBCu7rM5Vkw
                .opacity(coordinator.hideRootView ? 0 : 1)
                .scrollDisabled(coordinator.hideRootView)
                .allowsHitTesting(!coordinator.hideRootView)
                .overlay {
                    Detail()
                        .environment(coordinator)
                        .allowsHitTesting(coordinator.hideLayer)
                }
                //MARK: End of code written by Balaji Venkatesh for smooth detail zoom animation
                .background(.gray.opacity(0.15))
            }
        }
        .refreshable {
            await retryRequest()
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
                coordinator.toogleView(show: true, frame: frame, meal: meal)
            } label: {
                MealItem(meal: meal, isPreview: true)
            }
        }
        .frame(height: 220)
    }
}
