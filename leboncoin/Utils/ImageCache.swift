//
//  ImageCache.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 24/06/2023.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    private let service: ProductsServiceProtocol
    
    init(service: ProductsServiceProtocol = LeBonCoinApi()) {
        self.service = service
    }
    
    func loadImage(urlString: String?) async -> UIImage? {
        guard let urlString = urlString, let url = URL(string: urlString) else { return nil }
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            return imageFromCache as? UIImage
        }
        
        do {
            let imageData = try await service.getImage(url: url)
            guard let imageToCache = UIImage(data: imageData) else { return nil }
            imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
            return imageToCache
        } catch {
            return nil
        }
    }
}
