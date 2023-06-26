//
//  LeBonCoinApi.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 24/06/2023.
//

import Foundation

enum ApiError: Error {
    case invalidUrl
}

protocol ProductsServiceProtocol {
    func getProducts() async throws -> [Product]
    func getCategories() async throws -> [Category]
    func getImage(url: URL) async throws -> Data
}

final class LeBonCoinApi: ProductsServiceProtocol {
    
    enum Api {
        static let host: String = "https://raw.githubusercontent.com"
        static let basePath: String = "/leboncoin/paperclip/master"
        static let productsPath = "/listing.json"
        static let categoriesPath = "/categories.json"
    }
    
    func getProducts() async throws -> [Product] {
        let finalPath = "\(Api.host)\(Api.basePath)\(Api.productsPath)"
        
        guard let url = URL(string: finalPath) else { throw ApiError.invalidUrl }
        
        let urlRequest = URLRequest(url: url)
        do {
            let requestResponse = try await URLSession.shared.data(for: urlRequest)
            let data = requestResponse.0
            let items = try JSONDecoder().decode([Product].self, from: data)
            return items
        } catch let error {
            throw error
        }
    }
    
    func getCategories() async throws -> [Category] {
        let finalPath = "\(Api.host)\(Api.basePath)\(Api.categoriesPath)"
        
        guard let url = URL(string: finalPath) else { throw ApiError.invalidUrl }
        
        let urlRequest = URLRequest(url: url)
        do {
            let requestResponse = try await URLSession.shared.data(for: urlRequest)
            let data = requestResponse.0
            let items = try JSONDecoder().decode([Category].self, from: data)
            return items
        } catch let error {
            throw error
        }
    }
    
    func getImage(url: URL) async throws -> Data {
        let urlRequest = URLRequest(url: url)
        do {
            let requestResponse = try await URLSession.shared.data(for: urlRequest)
            let data = requestResponse.0
            return data
        } catch let error {
            throw error
        }
    }
    
}
