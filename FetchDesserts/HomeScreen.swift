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
                                await getDesserts()
                            }
                        } label: {
                            Text("Retry")
                        }
                    })
                } else {
                    AlphabetSidebarViewWithDrag(listView: ScrollView {
                        ImageGrid
                    }.scrollIndicators(.hidden), lookup: { letter in
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
                vm.resetValues()
                await getDesserts()
            }
        }
        .task {
            await getDesserts()
        }
    }
    
    func getDesserts() async {
        vm.error = nil
        await Network.shared.getDesserts(completion: { result in
            switch result {
            case .success(let response):
                withAnimation {
                    vm.meals = response.meals.sorted { meal1, meal2 in
                        meal1.strMeal < meal2.strMeal
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
            GridItem(.adaptive(minimum: 150, maximum: 160))
        ], alignment: .center, spacing: 25) {
            ForEach(vm.meals, id: \.self) { meal in
                Button {
                    isDetailPresented = true
                } label: {
                    MealItem(meal: meal)
                }
                .padding(.horizontal, 5)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct MealItem: View {
    @State var url: URL?
    var meal: Meal?
    let radius: CGFloat = 25
    
    var body: some View {
        CacheAsyncImage(url: URL(string: meal?.strMealThumb ?? "" + "/preview")!, transaction: .init(animation: .default)) { phase in
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
                    .clipShape(.rect(cornerRadius: radius))
            default:
                Placeholder {
                    ProgressView()
                }
            }
        }
        .aspectRatio(contentMode: .fit)
        .overlay(alignment: .bottom) {
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: radius, bottomTrailingRadius: radius, topTrailingRadius: 0)
                    .foregroundStyle(.thinMaterial)
                    .frame(height: 50)
                Text(meal?.strMeal ?? "")
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct Placeholder<Content: View>: View {
    @ViewBuilder let content: Content
    let radius: CGFloat = 25
    let halfGray: Color = .gray.opacity(0.5)
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .foregroundStyle(halfGray)
            .overlay {
                content
            }
    }
}

#Preview {
    HomeScreen()
}
