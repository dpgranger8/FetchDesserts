//
//  MealDetailScrollContent.swift
//  FetchDesserts
//
//  Created by David Granger on 5/14/24.
//

import SwiftUI
import YouTubePlayerKit

struct MealDetailScrollContent: View {
    //MARK: Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(Network.self) private var network
    var meal: Meal
    @State var vm = MealDetailVM()
    @State var showWebViewSheet: Bool = false
    let spacing: CGFloat = 15
    let lightBlue: Color = .blue.opacity(0.2)
    
    //MARK: UI
    var body: some View {
        VStack {
            if let errorMessage = vm.error {
                UnavailableView(message: errorMessage) {
                    Task {
                        await getMealDetail()
                    }
                }
            } else {
                VStack {
                    TitleHeader
                        .padding(.bottom, spacing / 2)
                    LazyVStack(alignment: .leading) {
                        Group {
                            RecipeTable
                            VideoSection
                            Instructions
                            LearnMore
                        }
                        .padding(.bottom, spacing / 2)
                    }
                    .padding(.bottom, spacing * 4)
                    .padding(.horizontal, spacing)
                }
            }
        }
        .background(colorScheme == .dark ? Statics.specialGray : Color(uiColor: .systemGroupedBackground))
        .task {
            await getMealDetail()
        }
    }
    
    //MARK: Functions
    func getMealDetail() async {
        vm.error = nil
        await network.getMealDetail(id: meal.idMeal, completion: { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    withAnimation {
                        vm.mealDetail = response
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
    private var TitleHeader: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.blue.gradient)
            Text(meal.strMeal)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding([.horizontal, .vertical], spacing)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    func Header(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.headline)
            .fontWeight(.heavy)
            .padding(.bottom, 10)
            .padding(.top, 15)
    }
    
    @ViewBuilder
    private var Instructions: some View {
        if let instructions = vm.mealDetail?.strInstructions {
            LeadingVStack {
                Header("Directions")
                Text(instructions)
            }
        }
    }
    
    @ViewBuilder
    private var RecipeTable: some View {
        if let items = vm.mealDetail?.ingredientsAndMeasures() {
            LeadingVStack {
                Header("Recipe")
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        Text("INGREDIENT")
                        Spacer()
                        Text("AMOUNT")
                    }
                    .padding(.bottom, 5)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    ForEach(items.indices, id: \.self) { index in
                        ZStack {
                            if index % 2 == 0 {
                                Rectangle()
                                    .fill(lightBlue.gradient)
                                    .padding(.horizontal, -15)
                            }
                            HStack {
                                Text(items[index].ingredient.capitalized)
                                Spacer()
                                Text(items[index].measure)
                            }
                            .font(.subheadline)
                        }
                        .frame(height: 30)
                    }
                }
                .padding(.horizontal, spacing)
                .padding(.vertical, spacing / 2)
                .background {
                    RoundedRectangle(cornerRadius: Statics.rectangleRadius / 2)
                        .fill(.quinary)
                }
            }
        }
    }
    
    @ViewBuilder
    private var VideoSection: some View {
        if let urlString = vm.mealDetail?.strYoutube {
            LeadingVStack {
                Header("Video")
                YouTubePlayerView(.init(source: .url(urlString))) { state in
                    switch state {
                    case .idle:
                        ProgressView()
                    case .ready:
                        EmptyView()
                    case .error(_):
                        EmptyView()
                    }
                }
                .frame(height: 300)
            }
        }
    }
    
    @ViewBuilder
    private var LearnMore: some View {
        if let source = vm.mealDetail?.strSource, let url = URL(string: source) {
            LeadingVStack {
                Header("Learn More")
                Button {
                    showWebViewSheet.toggle()
                } label: {
                    Text(source)
                        .foregroundStyle(.blue)
                }
            }
            .sheet(isPresented: $showWebViewSheet) {
                SafariView(url: url)
            }
        }
    }
}

struct LeadingVStack<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        VStack(alignment: .leading) {
            content
        }
    }
}

#Preview {
    MealDetailScrollContent(meal: Statics.dummyMeal)
}
