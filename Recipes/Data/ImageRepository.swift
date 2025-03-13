//
//  ImageRepository.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import Foundation
import UIKit

enum ImageError: Error {
    case badString
    case noImage
    case networkError
}

protocol ImageRepository {
    func getImage(urlString: String) async throws -> UIImage
}

class ImageRepositoryImpl: ImageRepository {
    private let api: ImageAPI
    private let cache: ImageCache
    
    init(api: ImageAPI,
         cache: ImageCache) {
        self.api = api
        self.cache = cache
    }
    
    func getImage(urlString: String) async throws -> UIImage {
        if let image = await cache.getImage(key: urlString) { return image }
        let image = try await api.getImage(urlString: urlString)
        await cache.setImage(image, key: urlString)
        return image
    }
}
