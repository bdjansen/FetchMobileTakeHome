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
    private let imageRepository: ImageRepositoryMock
    private let viewModel: RecipeCellViewModel
    
    init() {
        self.imageRepository = ImageRepositoryMock()
        let recipe = Recipe(
            cuisine: "testCuising",
            name: "testName",
            photo_url_large: "testPhotoLarge",
            photo_url_small: "testPhotoSmall",
            uuid: "testUUID",
            source_url: nil,
            youtube_url: nil
        )
        self.viewModel = RecipeCellViewModel(recipe: recipe, imageRepository: imageRepository)
    }
    
    @Test func load_failure() async throws {
        self.imageRepository.mockResponse = .failure(TestError.generic)
        await self.viewModel.load()
        guard case let .error(testObject) = viewModel.state else {
            Issue.record("")
            return
        }
        #expect(testObject is TestError)
    }

    @Test func load_success() async throws {
        let image = UIImage()
        self.imageRepository.mockResponse = .success(image)
        await self.viewModel.load()
        guard case let .loaded(testObject) = viewModel.state else {
            Issue.record("")
            return
        }
        #expect(testObject == image)
    }
    
    @Test func load_noImage() async throws {
        let recipe = Recipe(
            cuisine: "testCuising",
            name: "testName",
            photo_url_large: "testPhotoLarge",
            photo_url_small: nil,
            uuid: "testUUID",
            source_url: nil,
            youtube_url: nil
        )
        let viewModel = RecipeCellViewModel(recipe: recipe, imageRepository: imageRepository)
        await viewModel.load()
        guard case let .error(error) = viewModel.state else {
            Issue.record("The image should not load if there is not a link to pass.")
            return
        }
        #expect(error as? ImageError == .noImage)
    }
}
