//
//  ProductTableViewCell.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 24/06/2023.
//

import UIKit

final class ProductTableViewCell: UITableViewCell {
    
    // MARK: - UI properties
    
    private let titleLabel: UILabel = {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private let categoryLabel: UILabel = {
        $0.font = .italicSystemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private let priceLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16)
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
        $0.backgroundColor = .systemGray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = nil
        return $0
    }(UIImageView())
    
    private let stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private let priceAndUrgentView = UIView()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String,
                   category: String?,
                   price: String,
                   isUrgent: Bool,
                   imageUrlString: String?) {
        titleLabel.text = title
        categoryLabel.text = category
        priceLabel.text = price
        urgentLabel.isHidden = !isUrgent
        Task {
            do {
                productImageView.image = await ImageCache.shared.loadImage(urlString: imageUrlString)
            }
        }
    }
}

// MARK: - Private methods
private extension ProductTableViewCell {
    
    func configureView() {
        [stackView, titleLabel, categoryLabel, priceLabel, urgentLabel, priceAndUrgentView, productImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(stackView)
        contentView.addSubview(productImageView)
        
        priceAndUrgentView.addSubview(priceLabel)
        priceAndUrgentView.addSubview(urgentLabel)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(priceAndUrgentView)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.rightAnchor.constraint(equalTo: productImageView.leftAnchor, constant: -16),
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            productImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            priceLabel.leftAnchor.constraint(equalTo: priceAndUrgentView.leftAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceAndUrgentView.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: priceAndUrgentView.bottomAnchor),
            urgentLabel.rightAnchor.constraint(equalTo: priceAndUrgentView.rightAnchor),
            urgentLabel.topAnchor.constraint(equalTo: priceAndUrgentView.topAnchor),
            urgentLabel.bottomAnchor.constraint(equalTo: priceAndUrgentView.bottomAnchor)
        ])
    }
    
}
