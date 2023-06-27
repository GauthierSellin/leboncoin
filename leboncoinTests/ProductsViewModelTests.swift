//
//  ProductsViewModelTests.swift
//  leboncoinTests
//
//  Created by Gauthier Sellin on 26/06/2023.
//

import XCTest
@testable import leboncoin

final class LebonCoinApiMockSuccess: ProductsServiceProtocol {
    let categoriesMock = [Category(id: 1, name: "Voitures"),
                          Category(id: 2, name: "Maisons"),
                          Category(id: 3, name: "Mode")]
    let productsMock = [Product(id: 0, categoryId: 1, title: "voiture1", description: "",
                                price: 12.0, imagesUrl: ImagesUrl(small: nil, thumb: nil),
                                creationDateString: "2019-11-05T15:56:59+0000", isUrgent: true,
                                creationDate: nil, category: nil),
                        Product(id: 0, categoryId: 2, title: "maison", description: "",
                                price: 12.0, imagesUrl: ImagesUrl(small: nil, thumb: nil),
                                creationDateString: "2019-11-06T15:56:59+0000", isUrgent: false,
                                creationDate: nil, category: nil),
                        Product(id: 0, categoryId: 3, title: "pull", description: "",
                                price: 12.0, imagesUrl: ImagesUrl(small: nil, thumb: nil),
                                creationDateString: "2019-11-07T15:56:59+0000", isUrgent: true,
                                creationDate: nil, category: nil),
                        Product(id: 0, categoryId: 1, title: "voiture2", description: "",
                                price: 12.0, imagesUrl: ImagesUrl(small: nil, thumb: nil),
                                creationDateString: "2019-11-08T15:56:59+0000", isUrgent: false,
                                creationDate: nil, category: nil)]
    
    func getProducts() async throws -> [leboncoin.Product] {
        productsMock
    }
    
    func getCategories() async throws -> [leboncoin.Category] {
        categoriesMock
    }
    
    func getImage(url: URL) async throws -> Data {
        Data()
    }
}

final class LebonCoinApiMockFailure: ProductsServiceProtocol {
    func getProducts() async throws -> [leboncoin.Product] {
        throw ApiError.invalidUrl
    }
    
    func getCategories() async throws -> [leboncoin.Category] {
        throw ApiError.invalidUrl
    }
    
    func getImage(url: URL) async throws -> Data {
        throw ApiError.invalidUrl
    }
}

final class ProductsViewModelTests: XCTestCase {
    
    func testGetProductsWithLeBonCoinApiMockSuccess() {
        // Given
        let apiServiceMockSuccess = LebonCoinApiMockSuccess()
        let productsViewModel = ProductsViewModel(service: apiServiceMockSuccess)
        
        // When
        productsViewModel.getProducts()
        RunLoop.current.run(until: Date(timeInterval: 0.01, since: Date()))
        
        // Then
        XCTAssertEqual(productsViewModel.state, .success)
        XCTAssertEqual(productsViewModel.categories.count, 3)
        XCTAssertEqual(productsViewModel.displayedProducts.count, 4)
        XCTAssert(productsViewModel.displayedProducts[0].title == "pull")
        XCTAssert(productsViewModel.displayedProducts[0].category == "Mode")
        XCTAssert(productsViewModel.displayedProducts[1].title == "voiture1")
        XCTAssert(productsViewModel.displayedProducts[1].category == "Voitures")
        XCTAssert(productsViewModel.displayedProducts[2].title == "voiture2")
        XCTAssert(productsViewModel.displayedProducts[2].category == "Voitures")
        XCTAssert(productsViewModel.displayedProducts[3].title == "maison")
        XCTAssert(productsViewModel.displayedProducts[3].category == "Maisons")
    }
    
    func testGetProductsWithLeBonCoinApiMockFailure() {
        // Given
        let apiServiceMockFailure = LebonCoinApiMockFailure()
        let productsViewModel = ProductsViewModel(service: apiServiceMockFailure)
        
        // When
        productsViewModel.getProducts()
        RunLoop.current.run(until: Date(timeInterval: 0.01, since: Date()))
            
        // Then
        XCTAssert(productsViewModel.state == .error)
        XCTAssertEqual(productsViewModel.categories.count, 0)
        XCTAssertEqual(productsViewModel.displayedProducts.count, 0)
    }
    
    func testFilterProducts() {
        // Given
        let apiServiceMockSuccess = LebonCoinApiMockSuccess()
        let productsViewModel = ProductsViewModel(service: apiServiceMockSuccess)
        
        // When
        productsViewModel.getProducts()
        RunLoop.current.run(until: Date(timeInterval: 0.01, since: Date()))
        productsViewModel.filterProducts(newSelectedCategory: 1)
        RunLoop.current.run(until: Date(timeInterval: 0.01, since: Date()))
        
        // Then
        XCTAssertEqual(productsViewModel.categories.count, 3)
        XCTAssertEqual(productsViewModel.allProducts.count, 4)
        XCTAssertEqual(productsViewModel.displayedProducts.count, 2)
        XCTAssert(productsViewModel.displayedProducts[0].title == "voiture1")
        XCTAssert(productsViewModel.displayedProducts[0].category == "Voitures")
        XCTAssert(productsViewModel.displayedProducts[1].title == "voiture2")
        XCTAssert(productsViewModel.displayedProducts[1].category == "Voitures")
    }
    
}
