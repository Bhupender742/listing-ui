//
//  ViewController.swift
//  ListingUI
//
//  Created by Bhupender Rawat on 27/07/21.
//

import UIKit

class ViewController: UIViewController {
    
//    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0),
//                                              heightDimension: .fractionalHeight(0.2))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .fractionalWidth(1.0))
//
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
//        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [headerElement]
//
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//      }
    
    private var myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var categoryList = [Category]()

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
        myCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CustomCollectionViewCell.self))
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        self.myCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
//        myCollectionView.collectionViewLayout = createCompositionalLayout()
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
