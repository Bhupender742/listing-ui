//
//  FilterViewModel.swift
//  ListingUI
//
//  Created by Bhupender Rawat on 02/08/21.
//

import UIKit

class FilterViewModel: NSObject {
    
    private let urlString = "https://jsonkeeper.com/b/P419"
    
    public var categoryList = [Category]()
    public var excludeList = [[ExcludeList]]()
    public var selectedFilterList = [ExcludeList]()
    
}

extension FilterViewModel {
    
    public func fetchFilters(completion: @escaping () -> Void) {
        NetworkManager<APIResponse>().fetchData(from: urlString) { result in
            self.categoryList = result.data.categories
            self.excludeList = result.data.excludeList
            completion()
        }
    }
    
    public func getNumberOfSection() -> Int {
        return categoryList.count
    }
    
    public func getNumberOfItemsInSection(section: Int) -> Int {
        return categoryList[section].filters.count
    }
    
    public func getCategoryName(indexPath: IndexPath) -> String {
        return categoryList[indexPath.section].name
    }
    
    public func getFilterName(indexPath: IndexPath) -> String {
        return categoryList[indexPath.section].filters[indexPath.item].name
    }
    
    public func getCategoryID(indexPath: IndexPath) -> String {
        return categoryList[indexPath.section].categoryID
    }
    
    public func getFilterID(indexPath: IndexPath) -> String {
        return categoryList[indexPath.section].filters[indexPath.row].id
    }
    
}
