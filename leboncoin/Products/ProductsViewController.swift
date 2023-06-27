//
//  ProductsViewController.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 24/06/2023.
//

import Combine
import UIKit

final class ProductsViewController: UIViewController {
    
    // MARK: - Private UI properties
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    private let loader: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView(style: .large))
    
    // MARK: - Private properties
    private let viewModel: ProductsViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init(viewModel: ProductsViewModel = ProductsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        
        bindState()
        viewModel.getProducts()
    }
    
}

// MARK: - Private methods
private extension ProductsViewController {
    @objc func filterTapped() {
        let filterVC = FilterViewController(categories: viewModel.categories, selectedCategory: viewModel.selectedCategory)
        filterVC.delegate = self
        let navController = UINavigationController(rootViewController: filterVC)
        present(navController, animated: true, completion: nil)
    }
    
    func configureView() {
        navigationItem.title = "Leboncoin"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Catégories", style: .plain, target: self, action: #selector(filterTapped))
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(loader)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func bindState() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.startAndShowLoader()
                case .success, .error:
                    self?.hideAndStopLoader()
                }
            }.store(in: &subscriptions)
        
        viewModel.$displayedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
    }
    
    func startAndShowLoader() {
        tableView.isHidden = true
        loader.startAnimating()
        loader.isHidden = false
    }

    func hideAndStopLoader() {
        tableView.isHidden = false
        loader.isHidden = true
        loader.stopAnimating()
    }
}

// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.displayedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        let productToDisplay = viewModel.displayedProducts[indexPath.row]
        cell.configure(title: productToDisplay.title,
                       category: productToDisplay.category,
                       price: productToDisplay.price.formatPrice,
                       isUrgent: productToDisplay.isUrgent,
                       imageUrlString: productToDisplay.imagesUrl.small)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let productViewController = ProductViewController(product: viewModel.displayedProducts[indexPath.row])
        productViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productViewController, animated: true)
    }
}

// MARK: - FilterViewControllerDelegate
extension ProductsViewController: FilterViewControllerDelegate {
    func dismissViewController(_ controller: UIViewController, selectedCategory: Int?) {
        controller.dismiss(animated: true) { [weak self] in
            self?.viewModel.filterProducts(newSelectedCategory: selectedCategory)
        }
    }
}
