//
//  RecipeCellViewModel.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import Foundation
import UIKit

@MainActor
class RecipeCellViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case loaded(UIImage)
        case error(Error)
    }
    
    @Published var state: State = .initial
    let recipe: Recipe
    private let imageRepository: ImageRepository
    
    init(recipe: Recipe,
         imageRepository: ImageRepository) {
        self.recipe = recipe
        self.imageRepository = imageRepository
    }
    
    public func load() async {
        guard let urlString = recipe.photo_url_small else {
            self.state = .error(ImageError.noImage)
            return
        }
        self.state = .loading
        do {
            let image = try await self.imageRepository.getImage(urlString: urlString)
            self.state = .loaded(image)
        } catch {
            self.state = .error(error)
        }
    }
}

