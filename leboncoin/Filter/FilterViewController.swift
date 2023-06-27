//
//  FilterViewController.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func dismissViewController(_ controller: UIViewController, selectedCategory: Int?)
}

final class FilterViewController: UIViewController {
    
    // MARK: - Private UI properties
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(CategoryTableViewCell.self, forCellReuseIdentifier: "categoryCell")
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UITableView())
    
    // MARK: - Private properties
    private var categories = [Category]()
    private var selectedCategory: Int?
    
    weak var delegate: FilterViewControllerDelegate?
    
    // MARK: - Lifecycle
    convenience init(categories: [Category], selectedCategory: Int?) {
        self.init()
        self.categories = categories
        self.selectedCategory = selectedCategory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
    }
    
}

// MARK: - Private methods
private extension FilterViewController {
    
    func configureView() {
        navigationItem.title = "Catégories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryTableViewCell {
            cell.titleLabel.text = categories[indexPath.row].name
            cell.isSelectedCategory = selectedCategory == categories[indexPath.row].id
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.dismissViewController(self, selectedCategory: categories[indexPath.row].id)
    }
}
