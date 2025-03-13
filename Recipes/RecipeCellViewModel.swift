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
    private let service: RecipeListService
    
    init(recipe: Recipe,
         service: RecipeListService) {
        self.recipe = recipe
        self.service = service
    }
    
    public func load() async {
        self.state = .loading
        do {
            let image = try await self.service.getImage(recipe: recipe)
            self.state = .loaded(image)
        } catch {
            self.state = .error(error)
        }
    }
}

