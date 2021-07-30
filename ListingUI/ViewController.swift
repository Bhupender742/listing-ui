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
    
    var categoryList = [Category]()
    var excludeList = [[ExcludeList]]()
    var selectedFilterList = [ExcludeList]()
    var selectedIndexArray = [IndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://jsonkeeper.com/b/P419"
        
        setupCollectionView()
        styleCollectionView()
        
        NetworkManager<APIResponse>().fetchData(from: urlString) { (result) in
            self.categoryList = result.data.categories
            self.excludeList = result.data.excludeList
            self.myCollectionView.reloadData()
        }
    }

}

extension ViewController {
    
    private func setupCollectionView() {
        myCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        myCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CustomCollectionViewCell.self))
        
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
    
   
    
}

//MARK:- UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
       
        if let previousSelectedIndexArray = collectionView.indexPathsForSelectedItems?.filter( { $0.section == indexPath.section }) {
            if previousSelectedIndexArray.count > 0 {
                let previousSelectedIndex = previousSelectedIndexArray[0]
                let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndex) as! CustomCollectionViewCell
                collectionView.deselectItem(at: previousSelectedIndex, animated: false)
                previousSelectedCell.isSelected = false
                previousSelectedCell.toggleSelected()
                
                selectedIndexArray = selectedIndexArray.filter( { $0.section != previousSelectedIndex.section } )
                selectedFilterList = selectedFilterList.filter( { $0.categoryID != "\(previousSelectedIndex.section + 1)" })
            }
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        selectedFilterList.append(ExcludeList(categoryID: cell.categoryID, filterID: cell.filterID))
        selectedIndexArray.append(indexPath)
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        cell?.isSelected = true
        cell?.toggleSelected()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        selectedIndexArray = selectedIndexArray.filter( { $0 != indexPath })
        cell?.isSelected = false
        cell?.toggleSelected()
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
        categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryList[section].filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CustomCollectionViewCell.self), for: indexPath) as? CustomCollectionViewCell
        
        cell?.isSelected = false
        
        let filterName = categoryList[indexPath.section].filters[indexPath.item].name
        let categoryID = categoryList[indexPath.section].categoryID
        let filterID = categoryList[indexPath.section].filters[indexPath.row].id
        
        cell?.categoryID = categoryID
        cell?.filterID = filterID
        cell?.configure(filterName: filterName)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
             let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            sectionHeader.label.text = categoryList[indexPath.section].name
             return sectionHeader
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}
