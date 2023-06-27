//
//  ProductsViewModel.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 24/06/2023.
//

import Foundation

enum LoadingState {
    case loading
    case success
    case error
}

final class ProductsViewModel {
    
    // MARK: - Private properties
    private(set) var allProducts = [Product]()
    private(set) var categories = [Category]()
    private(set) var selectedCategory: Int?
    private let service: ProductsServiceProtocol
    
    @Published private(set) var state: LoadingState = .loading
    @Published private(set) var displayedProducts: [Product] = []
    
    init(service: ProductsServiceProtocol = LeBonCoinApi()) {
        self.service = service
    }
    
    func getProducts() {
        Task {
            do {
                let products = try await service.getProducts()
                let categories = try await service.getCategories()
                self.allProducts = products
                self.categories = categories
                updateAndSortProducts()
                self.state = .success
            } catch {
                self.state = .error
            }
        }
    }
    
    func filterProducts(newSelectedCategory: Int?) {
        if newSelectedCategory == selectedCategory {
            selectedCategory = nil
        } else {
            selectedCategory = newSelectedCategory
        }
        
        displayedProducts = selectedCategory == nil ? allProducts : allProducts.filter { $0.categoryId == selectedCategory }
        state = .success
    }
    
}

// MARK: - Private methods
private extension ProductsViewModel {
    func getCategory(product: Product) -> String? {
        categories.filter { $0.id == product.categoryId }.first?.name
    }
    
    func updateAndSortProducts() {
        allProducts.enumerated().forEach { index, product in
            allProducts[index].category = getCategory(product: product)
            allProducts[index].creationDate = product.creationDateString.formatDate
        }
        
        allProducts.sort { firstProduct, secondProduct in
            if let firstDate = firstProduct.creationDate, let secondDate = secondProduct.creationDate {
                switch (firstProduct.isUrgent, secondProduct.isUrgent) {
                case (true, false):
                    return true
                case (true, true), (false, false):
                    return firstDate.compare(secondDate) == .orderedDescending
                case (false, true):
                    return false
                }
            } else {
                return true
            }
        }
        
        displayedProducts = allProducts
    }
}
