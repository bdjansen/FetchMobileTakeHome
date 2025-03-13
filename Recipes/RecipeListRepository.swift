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
    private let urlSession: URLSession
    static let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func getRecipeList() async throws -> RecipeList {
        let response = try await self.urlSession.data(from: RecipeListRepositoryImpl.url)
        let (data, _) = response
        do {
            let recipeList = try JSONDecoder().decode(RecipeList.self, from: data)
            if recipeList.recipes.isEmpty {
                throw RecipeListError.empty
            }
            return recipeList
        } catch let error as RecipeListError {
            throw error
        } catch {
            throw RecipeListError.networkError
        }
    }
}
