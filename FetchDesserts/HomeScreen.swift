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
                                await retryNetwork()
                            }
                        } label: {
                            Text("Retry")
                        }
                    })
                } else {
                    AlphabetSidebarViewWithDrag(listView: ScrollView {
                        ImageGrid
                            .padding(.top, spacing)
                    }
                    .scrollIndicators(.hidden), lookup: { letter in
                        vm.meals.first { $0.strMeal.prefix(1).lowercased() == letter }
                    }, alphabetFiltered: alphabet.filter { letter in
                        vm.meals.contains { $0.strMeal.prefix(1).lowercased() == letter }
                    })
                    //TODO: sometimes dragging on the alphabet sidebar while images are loading causes an image load failure
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Daisy's Desserts")
            .navigationDestination(isPresented: $isDetailPresented) {
                VStack {
                    Text("Hello World")
                }
            }
            .refreshable {
                await retryNetwork()
            }
        }
        .task {
            await getDesserts()
        }
    }
    
    func retryNetwork() async {
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
    private var ImageGrid: some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 150, maximum: 160), spacing: spacing),
            GridItem(.adaptive(minimum: 150, maximum: 160), spacing: spacing)
        ], alignment: .center, spacing: spacing + 10) {
            ForEach(vm.meals, id: \.self) { meal in
                Button {
                    isDetailPresented = true
                } label: {
                    MealItem(meal: meal, isPreviewImage: true)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct MealItem: View {
    @Environment(\.colorScheme) var colorScheme
    @State var url: URL?
    var meal: Meal
    var isPreviewImage: Bool
    
    var body: some View {
        CacheAsyncImage(url: URL(string: meal.strMealThumb + (isPreviewImage ? "/preview" : ""))!, transaction: .init(animation: .default)) { phase in
            switch phase {
            case .failure:
                Placeholder {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .imageScale(.large)
                }
            case .success(let image):
                image
                    .resizable()
                    .clipShape(.rect(cornerRadius: Statics.rectangleRadius))
            default:
                Placeholder {
                    ProgressView()
                }
            }
        }
        .aspectRatio(contentMode: .fit)
        .overlay(alignment: .bottom) {
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: Statics.rectangleRadius, bottomTrailingRadius: Statics.rectangleRadius, topTrailingRadius: 0)
                    .foregroundStyle(.thinMaterial)
                    .frame(height: 50)
                Text(meal.strMeal)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .scaledToFit()
                    .minimumScaleFactor(0.7)
            }
            .offset(y: 10)
        }
    }
}

struct Placeholder<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        RoundedRectangle(cornerRadius: Statics.rectangleRadius)
            .foregroundStyle(Statics.halfGray)
            .overlay {
                content
            }
    }
}

#Preview {
    HomeScreen()
}
