//
//  TabBarController.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 23/06/2023.
//

import UIKit

final class TabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        
        let productsViewController = ProductsViewController()
        productsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let controllers = [productsViewController]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
