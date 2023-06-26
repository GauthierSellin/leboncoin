//
//  ProductViewController.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import UIKit

final class ProductViewController: UIViewController {
    
    // MARK: - Private UI properties
    
    private let stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private let titleLabel: UILabel = {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let categoryLabel: UILabel = {
        $0.font = .italicSystemFont(ofSize: 16)
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let priceLabel: UILabel = {
        $0.font = .boldSystemFont(ofSize: 20)
        return $0
    }(UILabel())
    
    private let dateLabel: UILabel = {
        $0.font = .boldSystemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private let urgentLabel: UILabel = {
        $0.textAlignment = .center
        $0.text = "URGENT "
        $0.textColor = .red
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.red.cgColor
        $0.font = .systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private let productImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - Private properties
    
    private let product: Product
    
    // MARK: - Lifecycle
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
    }
}

// MARK: - Private methods
private extension ProductViewController {
    
    func configureView() {
        navigationItem.title = "Détail"
        
        [stackView, titleLabel, categoryLabel, descriptionLabel, priceLabel, dateLabel, urgentLabel, productImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureStackView()
        
        titleLabel.text = product.title
        categoryLabel.text = product.category
        descriptionLabel.text = product.description
        priceLabel.text = product.price.formatPrice
        if let creationDate = product.creationDate?.formatString {
            dateLabel.text = "Mis en ligne le \(creationDate)"
        } else {
            dateLabel.isHidden = true
        }
        urgentLabel.isHidden = !product.isUrgent
        
        Task {
            do {
                productImageView.image = await ImageCache.shared.loadImage(urlString: product.imagesUrl.thumb)
            }
        }
        
        contentView.addSubview(stackView)
    }
    
    func configureScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(productImageView)
        stackView.addArrangedSubview(urgentLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            urgentLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // ScrollView and ContentView
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        // Other elements
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            urgentLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
