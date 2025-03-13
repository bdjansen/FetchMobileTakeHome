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
        let recipeListRepository = RecipeListRepositoryImpl(urlSession: .shared)
        let imageRepository = ImageRepositoryImpl(urlSession: .shared)
        let imageCache = ImageCacheImpl(persistanceContainer: NSPersistentContainer(name: "RecipeImageModel"))
        let service = RecipeListServiceImpl(recipeListRepository: recipeListRepository,
                                            imageRepository: imageRepository,
                                            imageCache: imageCache)
        let viewModel = RecipeListViewModel(service: service)
        return RecipeListView(viewModel: viewModel)
    }
}
