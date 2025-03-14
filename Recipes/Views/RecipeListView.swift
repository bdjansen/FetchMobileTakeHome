//
//  RecipeListView.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import SwiftUI

// Display a list of recipes.
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
                        RecipeCellView(viewModel: viewModel.cellViewModel(recipe: recipe))
                    }
                }
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
        .padding(.horizontal, 14)
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
