//
//  ImageStorage.swift
//  Recipes
//
//  Created by Blake Jansen on 3/11/25.
//

import Foundation
import UIKit
import CoreData

protocol ImageCache {
    func getImage(key: String) async -> UIImage?
    func setImage(_ image: UIImage, key: String) async
}

actor ImageCacheImpl: ImageCache {
    private let persistanceContainer: NSPersistentContainer
    
    init(persistanceContainer: NSPersistentContainer) {
        self.persistanceContainer = persistanceContainer
    }
    
    public func getImage(key: String) async -> UIImage? {
        let viewContext = self.persistanceContainer.viewContext
        let request = NSFetchRequest<ImageModel>(entityName: "ImageModel")
        request.predicate = NSPredicate(format: "url == %@", key)
        guard let imageModel = try? viewContext.fetch(request).first,
              let imageData = imageModel.image else { return nil }
        return UIImage(data: imageData)
    }
    
    public func setImage(_ image: UIImage, key: String) async {
        let viewContext = self.persistanceContainer.viewContext
        let entity = ImageModel(context: viewContext)
        entity.image = image.pngData()
        entity.url = key
    }
}
