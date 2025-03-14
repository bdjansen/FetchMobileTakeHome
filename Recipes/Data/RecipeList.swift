//
//  RecipeList.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

struct RecipeList: Codable, Equatable {
    let recipes: [Recipe]
}

/// A list of ingredients and instructions to prepare a meal. Includes a images and links for more information.
struct Recipe: Identifiable, Codable, Hashable, Equatable {
    var id: String { return uuid }
    let cuisine: String
    let name: String
    let photo_url_large: String?
    let photo_url_small: String?
    let uuid: String
    let source_url: String?
    let youtube_url: String?
}
