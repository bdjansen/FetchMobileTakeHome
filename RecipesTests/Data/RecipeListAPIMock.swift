//
//  RecipeListAPIMock.swift
//  Recipes
//
//  Created by Blake Jansen on 3/13/25.
//


@testable import Recipes

class RecipeListAPIMock: RecipeListAPI {
    var mockResponse: Result<RecipeList, Error> = .failure(RecipeListError.networkError)
    func getRecipeList() async throws -> Recipes.RecipeList {
        switch mockResponse {
        case .success(let recipeList):
            return recipeList
        case .failure(let error):
            throw error
        }
    }
}
