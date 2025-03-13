//
//  RecipeListView.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                RecipeListStateView(viewModel: viewModel)
            }
            .refreshable { await viewModel.load() }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .task { await viewModel.load() }
    }
}

struct RecipeListStateView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded:
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.getFilteredRecipes(), id: \.uuid) { recipe in
                        RecipeCell(viewModel: viewModel.cellViewModel(recipe: recipe))
                    }
                }
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
        .padding(.horizontal, 14)
    }
}

struct RecipeCell: View {
    @StateObject var viewModel: RecipeCellViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Group {
                switch viewModel.state {
                case .initial:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .loaded(let uIImage):
                    Image(uiImage: uIImage)
                        .resizable()
                case .error:
                    Image(systemName: "x.circle")
                        .resizable()
                }
            }
            .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Text(viewModel.recipe.name)
                    .font(.headline)
                Text(viewModel.recipe.cuisine)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 2)
        )
        .task {
            await viewModel.load()
        }
    }
}

extension RecipeListError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .empty:
            return "We don't seem to have any recipes available right now. Please try again later."
        case .networkError:
            return "Failed to retrieve recipes. Please try again later."
        }
    }
}
