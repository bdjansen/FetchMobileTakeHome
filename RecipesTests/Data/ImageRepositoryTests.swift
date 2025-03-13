//
//  ImageRepositoryTests.swift
//  RecipesTests
//
//  Created by Blake Jansen on 3/13/25.
//

import Testing
@testable import Recipes
import UIKit

struct ImageRepositoryTests {
    private let api: ImageAPIMock
    private let cache: ImageCacheMock
    private let repository: ImageRepositoryImpl
    
    init() {
        self.api = ImageAPIMock()
        self.cache = ImageCacheMock()
        self.repository = ImageRepositoryImpl(api: api, cache: cache)
    }
    
    @Test func getImage_cache() async throws {
        let image = UIImage()
        self.cache.getImageResponse = image
        self.api.mockResponse = .failure(ImageError.networkError)
        let testObject = try await self.repository.getImage(urlString: "testString")
        #expect(image == testObject)
    }
    
    @Test func getImage_failure() async throws {
        let error = ImageError.networkError
        self.api.mockResponse = .failure(error)
        await #expect(throws: error) {
            try await repository.getImage(urlString: "testString")
        }
    }
    
    @Test func getImage_success() async throws {
        let image = UIImage()
        self.api.mockResponse = .success(image)
        let testObject = try await repository.getImage(urlString: "testString")
        #expect(testObject == image)
    }
}

