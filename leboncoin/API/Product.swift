//
//  Product.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import Foundation

struct Product: Codable {
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Double
    let imagesUrl: ImagesUrl
    let creationDateString: String
    let isUrgent: Bool
    var creationDate: Date?
    var category: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case title
        case description
        case price
        case imagesUrl = "images_url"
        case creationDateString = "creation_date"
        case isUrgent = "is_urgent"
    }
}

struct ImagesUrl: Codable {
    let small: String?
    let thumb: String?
}
