//
//  ImageCacheMock.swift
//  Recipes
//
//  Created by Blake Jansen on 3/12/25.
//

@testable import Recipes
import UIKit

class ImageCacheMock: ImageCache {
    var getImageResponse: UIImage?
    func getImage(key: String) async -> UIImage? {
        return getImageResponse
    }
    
    var setImageResponse: UIImage?
    func setImage(_ image: UIImage, key: String) async {
        setImageResponse = image
    }
}
