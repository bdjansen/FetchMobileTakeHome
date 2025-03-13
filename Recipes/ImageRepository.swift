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
    func get(urlString: String) async throws -> UIImage
}

class ImageRepositoryImpl: ImageRepository {
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func get(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { throw ImageError.badString }
        do {
            let response = try await self.urlSession.data(from: url)
            let (data, _) = response
            guard let image = UIImage(data: data) else { throw ImageError.noImage }
            return image
        } catch let error as ImageError {
            throw error
        } catch {
            throw ImageError.networkError
        }
    }
}
