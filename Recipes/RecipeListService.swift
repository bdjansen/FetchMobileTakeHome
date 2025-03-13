//
//  RecipeListService.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import Foundation
import UIKit

protocol RecipeListService {
    func getRecipeList() async throws -> RecipeList
    func getImage(recipe: Recipe) async throws -> UIImage
}

class RecipeListServiceImpl: RecipeListService {
    private let recipeListRepository: RecipeListRepository
    private let imageRepository: ImageRepository
    private let imageCache: ImageCache
    
    init(recipeListRepository: RecipeListRepository,
         imageRepository: ImageRepository,
         imageCache: ImageCache) {
        self.recipeListRepository = recipeListRepository
        self.imageRepository = imageRepository
        self.imageCache = imageCache
    }
    
    func getRecipeList() async throws -> RecipeList {
        try await recipeListRepository.getRecipeList()
    }
    
    func getImage(recipe: Recipe) async throws -> UIImage {
        guard let photo_url_small = recipe.photo_url_small else { throw ImageError.noImage }
        if let image = await imageCache.getImage(key: photo_url_small) { return image }
        let image = try await imageRepository.get(urlString: photo_url_small)
        await imageCache.setImage(image, key: photo_url_small)
        return image
    }
}
