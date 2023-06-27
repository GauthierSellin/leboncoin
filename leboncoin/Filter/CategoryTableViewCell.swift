//
//  CategoryTableViewCell.swift
//  leboncoin
//
//  Created by Gauthier Sellin on 25/06/2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - UI properties
    let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
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
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ])
    }
    
}
