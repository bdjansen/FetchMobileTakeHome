//
//  RecipeListRepositoryMock.swift
//  RecipesTests
//
//  Created by Blake Jansen on 3/11/25.
//

@testable import Recipes

enum TestError: Error {
    case generic
}

class RecipeListRepositoryMock: RecipeListRepository {
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
