//
//  CategoryTableViewCell.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - UI properties
    let titleLabel = UILabel()
    
    // MARK: - Properties
    var isSelectedCategory = false {
        didSet {
            titleLabel.font = isSelectedCategory ? UIFont.boldSystemFont(ofSize: 17) : UIFont.systemFont(ofSize: 17)
            titleLabel.textColor = isSelectedCategory ? .red : .none
        }
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension CategoryTableViewCell {
    
    func configureView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
}
