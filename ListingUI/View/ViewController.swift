//
//  ViewController.swift
//  ListingUI
//
//  Created by Bhupender Rawat on 27/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var filterModel = FilterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        styleCollectionView()
        
        filterModel.fetchFilters {
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
        
    }

}

extension ViewController {
    
    private func setupCollectionView() {
        myCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        myCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseIdentifier)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    
    private func styleCollectionView() {
        self.view.addSubview(myCollectionView)
        NSLayoutConstraint.activate([
                                        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                        myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                        myCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                        myCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        myCollectionView.backgroundColor = .white
        myCollectionView.allowsMultipleSelection = true
    }
    
    private func containsExcludeList(indexPath: IndexPath) -> Bool {
        let selectedFilterSet = NSSet(array: filterModel.selectedFilterList)
        
        for excludeFilter in filterModel.excludeList {
            let excludeFilterSet  = NSSet(array: excludeFilter)
            if excludeFilterSet.isSubset(of: selectedFilterSet as! Set<AnyHashable>) {
                filterModel.selectedFilterList = filterModel.selectedFilterList.filter( { $0.categoryID != "\(indexPath.section + 1)"})
                
                let refreshAlert = UIAlertController(title: "Sorry :(", message: "Current selection not available", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(refreshAlert, animated: true, completion: nil)
                
                return false
            }
            
        }
        return true
    }
    
}

//MARK:- UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
       
        if let previousSelectedIndexArray = collectionView.indexPathsForSelectedItems?.filter( { $0.section == indexPath.section }) {
            if previousSelectedIndexArray.count > 0 {
                let previousSelectedIndex = previousSelectedIndexArray[0]
                let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndex) as! FilterCell
                collectionView.deselectItem(at: previousSelectedIndex, animated: false)
                previousSelectedCell.isSelected = false
                
                filterModel.selectedFilterList = filterModel.selectedFilterList.filter( { $0.categoryID != "\(previousSelectedIndex.section + 1)" })
            }
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
        filterModel.selectedFilterList.append(ExcludeList(categoryID: cell.categoryID, filterID: cell.filterID))
        
        return containsExcludeList(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FilterCell
        cell?.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FilterCell
        filterModel.selectedFilterList = filterModel.selectedFilterList.filter( { $0.categoryID != "\(indexPath.section + 1)"})
        cell?.isSelected = false
    }
    
    
}

//MARK:- UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
    
}

//MARK:- UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filterModel.getNumberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterModel.getNumberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCell.self), for: indexPath) as? FilterCell
        
        let filterName = filterModel.getFilterName(indexPath: indexPath)
        let categoryID = filterModel.getCategoryID(indexPath: indexPath)
        let filterID = filterModel.getFilterID(indexPath: indexPath)
        
        cell?.categoryID = categoryID
        cell?.filterID = filterID
        cell?.configure(filterName: filterName)
        
        cell?.isSelected = false
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
            sectionHeader.label.text = filterModel.getCategoryName(indexPath: indexPath)
             return sectionHeader
        } else { 
             return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

