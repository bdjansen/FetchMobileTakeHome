//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Blake Jansen on 3/11/25.
//

import Testing
@testable import Recipes
import UIKit

struct RecipeListServiceTests {
    private let repository: RecipeListRepositoryMock
    private let imageRepository: ImageRepositoryMock
    private let imageCache: ImageCacheMock
    private let service: RecipeListServiceImpl
    
    init() {
        self.repository = RecipeListRepositoryMock()
        self.imageRepository = ImageRepositoryMock()
        self.imageCache = ImageCacheMock()
        self.service = RecipeListServiceImpl(recipeListRepository: repository,
                                             imageRepository: imageRepository,
                                             imageCache: imageCache)
    }
    
    @Test func getRecipeList_failure() async throws {
        self.repository.mockResponse = .failure(TestError.generic)
        await #expect(throws: TestError.generic) {
            try await self.service.getRecipeList()
        }
    }

    @Test func getRecipeList_success() async throws {
        let recipeList = RecipeList(recipes: [])
        self.repository.mockResponse = .success(recipeList)
        let testObject = try await self.service.getRecipeList()
        #expect(testObject == recipeList)
    }
    
    @Test func getImage_nil() async throws {
        let recipe = Recipe.testWithoutImage()
        await #expect(throws: ImageError.noImage) {
            try await self.service.getImage(recipe: recipe)
        }
    }
    
    @Test func getImage_cacheHit() async throws {
        let recipe = Recipe.testWithImage()
        let image = UIImage()
        self.imageCache.getImageResponse = image
        self.imageRepository.mockResponse = .failure(TestError.generic)
        let testObject = try await self.service.getImage(recipe: recipe)
        #expect(testObject == image)
    }
    
    @Test func getImage_failureLoad() async throws {
        let recipe = Recipe.testWithImage()
        self.imageCache.getImageResponse = nil
        self.imageRepository.mockResponse = .failure(TestError.generic)
        await #expect(throws: TestError.generic) {
            try await self.service.getImage(recipe: recipe)
        }
    }
    
    @Test func getImage_successLoad() async throws {
        let recipe = Recipe.testWithImage()
        let image = UIImage()
        self.imageCache.getImageResponse = nil
        self.imageRepository.mockResponse = .success(image)
        let testObject = try await self.service.getImage(recipe: recipe)
        #expect(testObject == image)
    }
    
    @Test func getImage_cachesResult() async throws {
        let recipe = Recipe.testWithImage()
        let image = UIImage()
        self.imageRepository.mockResponse = .success(image)
        let _ = try await self.service.getImage(recipe: recipe)
        #expect(self.imageCache.setImageResponse == image)
    }
}

private extension Recipe {
    static func testWithImage(_ differentiator: String = "1") -> Recipe {
        Recipe(
            cuisine: "testCuisine\(differentiator)",
            name: "testName\(differentiator)",
            photo_url_large: "testLargePhoto\(differentiator)",
            photo_url_small: "testSmallPhoto\(differentiator)",
            uuid: "testUUID\(differentiator)",
            source_url: "testSourceUrl\(differentiator)",
            youtube_url: "testYoutubeUrl\(differentiator)"
        )
    }
    
    static func testWithoutImage(_ differentiator: String = "1") -> Recipe {
        Recipe(
            cuisine: "testCuisine\(differentiator)",
            name: "testName\(differentiator)",
            photo_url_large: nil,
            photo_url_small: nil,
            uuid: "testUUID\(differentiator)",
            source_url: "testSourceUrl\(differentiator)",
            youtube_url: "testYoutubeUrl\(differentiator)"
        )
    }
}
