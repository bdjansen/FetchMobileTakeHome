//
//  RecipeListServiceMock.swift
//  RecipesTests
//
//  Created by Blake Jansen on 3/11/25.
//

@testable import Recipes
import UIKit

class RecipeListServiceMock: RecipeListService {
    var mockResponse: Result<RecipeList, Error> = .failure(TestError.generic)
    func getRecipeList() async throws -> Recipes.RecipeList {
        switch mockResponse {
        case .success(let recipeList):
            return recipeList
        case .failure(let error):
            throw error
        }
    }
    
    var mockImageReponse: Result<UIImage, Error> = .failure(TestError.generic)
    func getImage(recipe: Recipes.Recipe) async throws -> UIImage {
        switch mockImageReponse {
        case .success(let image):
            return image
        case .failure(let error):
            throw error
        }
    }
}
