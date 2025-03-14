//
//  RecipesApp.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import SwiftUI
import CoreData

@main
struct RecipesApp: App {
    var body: some Scene {
        WindowGroup {
            if NSClassFromString("XCTest") != nil {
                EmptyView()
            } else {
                getRecipeView()
            }
        }
    }
    
    private func getRecipeView() -> RecipeListView {
        let recipeListApi = RecipeListAPIImpl(urlSession: .shared, retrievalType: .base)
        let recipeListRepository = RecipeListRepositoryImpl(api: recipeListApi)
        let imageApi = ImageAPIImpl(urlSession: .shared)
        let imageCache = ImageCacheImpl(persistanceContainer: NSPersistentContainer(name: "RecipeImageModel"))
        let imageRepository = ImageRepositoryImpl(api: imageApi, cache: imageCache)
        let viewModel = RecipeListViewModel(recipeListRepository: recipeListRepository,
                                            imageRepository: imageRepository)
        return RecipeListView(viewModel: viewModel)
    }
}
