//
//  SectionHeader.swift
//  ListingUI
//
//  Created by Bhupender Rawat on 27/07/21.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
   }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}

extension SectionHeader: Reusable {}
