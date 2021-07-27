//
//  ListModel.swift
//  ListingUI
//
//  Created by Bhupender Rawat on 27/07/21.
//

import Foundation

struct APIResponse: Codable {
    let categories: [Category]?
    let excludeList: [List]?
    
    enum CodingKeys: String, CodingKey {
        case categories
        case excludeList = "exclude_list"
    }
}

struct Category: Codable {
    let id: String?
    let filters: [Filter]?
    
    enum CodingKeys: String, CodingKey {
        case id =  "category_id"
        case filters
    }
    
}

struct Filter: Codable {
    let defaultValue: Int?
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case defaultValue = "default"
        case id
        case name
    }
}

struct List: Codable {
    let categoryId: String?
    let filterId: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case filterId = "filter_id"
    }
}
