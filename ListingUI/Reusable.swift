//
//  Reusable.swift
//  ListingUI
//
//  Created by Bhupender Rawat on 31/07/21.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
