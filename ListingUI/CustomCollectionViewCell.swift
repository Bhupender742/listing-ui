//
//  CustomCollectionViewCell.swift
//  ListingUI
//
//  Created by Bhupender Rawat on 27/07/21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomCollectionViewCell {
    
    private func setupViews() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
                                        containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        addSubview(categoryLabel)
        NSLayoutConstraint.activate([
                                        categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                                        categoryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
                                        categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        ])
    }
    
    public func configure(categoryName: String) {
        categoryLabel.text = categoryName
    }
    
}
