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
    var error: String?
}

struct HomeScreen: View {
    @State var vm = HomeScreenVM()
    
    var body: some View {
        NavigationStack {
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
                ScrollView {
                    ImageGrid
                }
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
                vm.meals = response.meals
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
                ImageFromURL(url: meal.strMealThumb)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ImageFromURL: View {
    var url: String? = "https://hws.dev/paul3.jpg"
    
    var body: some View {
        AsyncImage(url: URL(string: url ?? "")) { phase in
            switch phase {
            case .failure:
                RoundedRectangle(cornerRadius: 25)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    }
            case .success(let image):
                image
                    .resizable()
            default:
                ProgressView()
            }
        }
        .aspectRatio(contentMode: .fit)
        .clipShape(.rect(cornerRadius: 25))
    }
}

#Preview {
    HomeScreen()
}
