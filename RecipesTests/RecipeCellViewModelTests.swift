//
//  RecipeCellViewModelTests.swift
//  RecipesTests
//
//  Created by Blake Jansen on 3/12/25.
//

import Testing
@testable import Recipes
import UIKit

@MainActor
struct RecipeCellViewModelTests {
    private let service: RecipeListServiceMock
    private let viewModel: RecipeCellViewModel
    
    init() {
        self.service = RecipeListServiceMock()
        let recipe = Recipe(
            cuisine: "testCuising",
            name: "testName",
            photo_url_large: "testPhotoLarge",
            photo_url_small: "testPhotoSmall",
            uuid: "testUUID",
            source_url: nil,
            youtube_url: nil
        )
        self.viewModel = RecipeCellViewModel(recipe: recipe, service: service)
    }
    
    @Test func load_failure() async throws {
        self.service.mockImageReponse = .failure(TestError.generic)
        await self.viewModel.load()
        guard case let .error(testObject) = viewModel.state else {
            Issue.record("")
            return
        }
        #expect(testObject is TestError)
    }

    @Test func load_success() async throws {
        let image = UIImage()
        self.service.mockImageReponse = .success(image)
        await self.viewModel.load()
        guard case let .loaded(testObject) = viewModel.state else {
            Issue.record("")
            return
        }
        #expect(testObject == image)
    }
}
