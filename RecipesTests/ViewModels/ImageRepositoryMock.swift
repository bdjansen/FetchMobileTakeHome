//
//  ImageRepositoryMock.swift
//  RecipesTests
//
//  Created by Blake Jansen on 3/11/25.
//

@testable import Recipes
import UIKit

class ImageRepositoryMock: ImageRepository {
    var mockResponse: Result<UIImage, Error> = .failure(ImageError.networkError)
    func getImage(urlString: String) async throws -> UIImage {
        switch mockResponse {
        case .success(let image):
            return image
        case .failure(let error):
            throw error
        }
    }
}
