//
//  RecipeListRepositoryTests.swift
//  RecipesTests
//
//  Created by Blake Jansen on 3/13/25.
//

import Testing
@testable import Recipes

struct RecipeListRepositoryTests {
    private let api: RecipeListAPIMock
    private let repository: RecipeListRepositoryImpl
    
    init() {
        self.api = RecipeListAPIMock()
        self.repository = RecipeListRepositoryImpl(api: api)
    }
    
    @Test func getRecipeList_failure() async throws {
        let error = RecipeListError.networkError
        self.api.mockResponse = .failure(error)
        await #expect(throws: error) {
            try await repository.getRecipeList()
        }
    }
    
    @Test func getRecipeList_success() async throws {
        let recipes = [Recipe(
            cuisine: "testCuising",
            name: "testName",
            photo_url_large: "testPhotoLarge",
            photo_url_small: "testPhotoSmall",
            uuid: "testUUID",
            source_url: nil,
            youtube_url: nil
        )]
        let recipeList = RecipeList(recipes: recipes)
        self.api.mockResponse = .success(recipeList)
        let testObject = try await repository.getRecipeList()
        #expect(testObject == recipeList)
    }
    
    @Test func getRecipeList_empty() async throws {
        let recipeList = RecipeList(recipes: [])
        self.api.mockResponse = .success(recipeList)
        await #expect(throws: RecipeListError.empty) {
            try await repository.getRecipeList()
        }
    }
}
