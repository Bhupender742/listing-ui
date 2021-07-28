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
    var selectedIndex = [IndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://app.fakejson.com/q/WZSqwXlJ?token=g1BRxoj_H1TIYVEUqbWrRg"
        
        setupCollectionView()
        styleCollectionView()
        
        NetworkManager<APIResponse>().fetchData(from: urlString) { (result) in
            self.categoryList = result.categories
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
    }
    
}

//MARK:- UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
        print(indexPath)
        cell?.isSelected = true
        cell?.toggleSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
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
        
        let categoryName = categoryList[indexPath.section].filters[indexPath.item].name
        cell?.configure(categoryName: categoryName)
        
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
