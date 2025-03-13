//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case loaded(RecipeList)
        case error(Error)
    }
    
    @Published var state: State = .initial
    @Published var searchText: String = ""
    private let service: RecipeListService
    
    init(service: RecipeListService) {
        self.service = service
    }
    
    public func load() async {
        self.state = .loading
        do {
            let recipeList = try await service.getRecipeList()
            self.state = .loaded(recipeList)
        } catch {
            self.state = .error(error)
        }
    }
    
    public func getFilteredRecipes() -> [Recipe] {
        guard case let .loaded(recipeList) = self.state else { return [] }
        if searchText.isEmpty { return recipeList.recipes }
        return recipeList.recipes.filter { $0.cuisine.contains(searchText) || $0.name.contains(searchText) }
    }
    
    public func cellViewModel(recipe: Recipe) -> RecipeCellViewModel {
        return RecipeCellViewModel(recipe: recipe, service: service)
    }
}
