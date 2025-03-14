//
//  RecipeListAPI.swift
//  Recipes
//
//  Created by Blake Jansen on 3/13/25.
//

import Foundation

/// Object to to retrieve a list of recipes from a network store.
protocol RecipeListAPI {
    /// Retrieve a list of recipes.
    func getRecipeList() async throws -> RecipeList
}

class RecipeListAPIImpl: RecipeListAPI {
    enum RecipeListLinkType: String {
        case base = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        
        func url() -> URL {
            URL(string: rawValue)!
        }
    }
    
    private let urlSession: URLSession
    private let retrievalType: RecipeListLinkType
    
    init(urlSession: URLSession,
         retrievalType: RecipeListLinkType) {
        self.urlSession = urlSession
        self.retrievalType = retrievalType
    }
    
    func getRecipeList() async throws -> RecipeList {
        let recipeList: RecipeList
        do {
            let response = try await self.urlSession.data(from: retrievalType.url())
            let (data, _) = response
            recipeList = try JSONDecoder().decode(RecipeList.self, from: data)
        } catch {
            throw RecipeListError.networkError
        }
        return recipeList
    }
}
