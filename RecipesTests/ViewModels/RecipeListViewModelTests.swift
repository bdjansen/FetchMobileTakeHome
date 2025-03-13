//
//  RecipeListViewModelTests.swift
//  RecipesTests
//
//  Created by Blake Jansen on 3/11/25.
//

import Testing
@testable import Recipes

@MainActor
struct RecipeListViewModelTests {
    private let recipeListRepository: RecipeListRepositoryMock
    private let imageRepository: ImageRepositoryMock
    private let viewModel: RecipeListViewModel
    
    init() {
        self.recipeListRepository = RecipeListRepositoryMock()
        self.imageRepository = ImageRepositoryMock()
        self.viewModel = RecipeListViewModel(recipeListRepository: recipeListRepository,
                                             imageRepository: imageRepository)
    }

    @Test(arguments: [RecipeListError.empty, RecipeListError.networkError])
    func stateFailure(error: RecipeListError) async throws {
        self.recipeListRepository.mockResponse = .failure(error)
        await self.viewModel.load()
        guard case let .error(testError) = viewModel.state else {
            Issue.record("ViewModel successfully loaded")
            return
        }
        #expect(testError is RecipeListError)
    }

    @Test
    func stateSuccess() async throws {
        let testList = RecipeList.testObject()
        self.recipeListRepository.mockResponse = .success(testList)
        await self.viewModel.load()
        guard case let .loaded(recipeList) = viewModel.state else {
            Issue.record("ViewModel failed to load")
            return
        }
        #expect(recipeList == testList)
    }
    
    @Test
    func getFilteredRecipes_badState() async throws {
        #expect(self.viewModel.getFilteredRecipes() == [])
    }
    
    @Test
    func getFilteredRecipes_noSearchText() async throws {
        let recipeList = RecipeList.testObject()
        self.recipeListRepository.mockResponse = .success(recipeList)
        await self.viewModel.load()
        #expect(viewModel.getFilteredRecipes() == recipeList.recipes)
    }
    
    @Test
    func getFilteredRecipes_singleMatch() async throws {
        let recipeList = RecipeList.testObject()
        self.recipeListRepository.mockResponse = .success(recipeList)
        await self.viewModel.load()
        self.viewModel.searchText = "1"
        #expect(viewModel.getFilteredRecipes() == [recipeList.recipes.first])
    }
    
    @Test
    func getFilteredRecipes_allMatch() async throws {
        let recipeList = RecipeList.testObject()
        self.recipeListRepository.mockResponse = .success(recipeList)
        await self.viewModel.load()
        self.viewModel.searchText = "test"
        #expect(viewModel.getFilteredRecipes() == recipeList.recipes)
    }
    
    @Test
    func cellViewModel() async throws {
        let recipe = Recipe.testObject()
        let cellViewModel = viewModel.cellViewModel(recipe: recipe)
        #expect(cellViewModel.recipe == recipe)
    }
}

private extension RecipeList {
    static func testObject() -> RecipeList {
        return RecipeList(recipes: [.testObject("1"), .testObject("2")])
    }
}

private extension Recipe {
    static func testObject(_ differentiator: String = "1") -> Recipe {
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
}
