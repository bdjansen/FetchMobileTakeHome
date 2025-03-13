//
//  RecipeListAPI.swift
//  Recipes
//
//  Created by Blake Jansen on 3/13/25.
//

import Foundation

protocol RecipeListAPI {
    func getRecipeList() async throws -> RecipeList
}

class RecipeListAPIImpl: RecipeListAPI {
    private let urlSession: URLSession
    static let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func getRecipeList() async throws -> RecipeList {
        let recipeList: RecipeList
        do {
            let response = try await self.urlSession.data(from: RecipeListAPIImpl.url)
            let (data, _) = response
            recipeList = try JSONDecoder().decode(RecipeList.self, from: data)
        } catch {
            throw RecipeListError.networkError
        }
        return recipeList
    }
}
