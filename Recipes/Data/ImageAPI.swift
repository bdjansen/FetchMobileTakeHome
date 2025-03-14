//
//  ImageAPI.swift
//  Recipes
//
//  Created by Blake Jansen on 3/13/25.
//

import Foundation
import UIKit

/// Object to to retrieve an image from a network store.
protocol ImageAPI {
    /// Retrieve an image for a given url.
    func getImage(urlString: String) async throws -> UIImage
}

class ImageAPIImpl: ImageAPI {
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func getImage(urlString: String) async throws -> UIImage {
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
