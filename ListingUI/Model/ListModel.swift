//
//  ListModel.swift
//  ListingUI
//
//  Created by Bhupender Rawat on 27/07/21.
//

import Foundation

// MARK: - APIResponse
struct APIResponse: Codable {
    let data: Datum
}

// MARK: - Data
struct Datum: Codable {
    let categories: [Category]
    let excludeList: [[ExcludeList]]

    enum CodingKeys: String, CodingKey {
        case categories
        case excludeList = "exclude_list"
    }
}

// MARK: - Category
struct Category: Codable {
    let categoryID: String
    let filters: [Filter]
    let name: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case filters, name
    }
}

// MARK: - Filter
struct Filter: Codable {
    let filterDefault: Int
    let id, name: String

    enum CodingKeys: String, CodingKey {
        case filterDefault = "default"
        case id, name
    }
}

// MARK: - ExcludeList
struct ExcludeList: Codable, Equatable {
    let categoryID, filterID: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case filterID = "filter_id"
    }
}
