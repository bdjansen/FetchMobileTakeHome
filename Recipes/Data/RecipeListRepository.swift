//
//  RecipeListRepository.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import Foundation

protocol RecipeListRepository {
    func getRecipeList() async throws -> RecipeList
}

enum RecipeListError: Error {
    case empty
    case networkError
}

class RecipeListRepositoryImpl: RecipeListRepository {
    private let api: RecipeListAPI
    
    init(api: RecipeListAPI) {
        self.api = api
    }
    
    func getRecipeList() async throws -> RecipeList {
        let recipeList = try await api.getRecipeList()
        if recipeList.recipes.isEmpty {
            throw RecipeListError.empty
        }
        return recipeList
    }
}
