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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    var categoryList = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://app.fakejson.com/q/WZSqwXlJ?token=g1BRxoj_H1TIYVEUqbWrRg"
        
        setupCollectionView()
        styleCollectionView()
        
        NetworkManager<APIResponse>().fetchData(from: urlString) { (result) in
            self.categoryList = result.categories ?? []
            self.myCollectionView.reloadData()
        }
    }


}

extension ViewController {
    
    private func setupCollectionView() {
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
    }
    
}

//MARK:- UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

//MARK:- UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }

}
