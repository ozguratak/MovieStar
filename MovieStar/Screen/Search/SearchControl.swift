//
//  SearchControl.swift
//  MovieStar
//
//  Created by obss on 17.01.2023.
//

import UIKit

class SearchControl: UIViewController {

    @IBOutlet weak var searchTypesCollectionView: UICollectionView!
    private let categories: [String] = ["By Movie Name", "By Production Company", "By Actor", "By Categories", "General Search"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringKey.searchPageHeader
        searchTypesCollectionView.delegate = self
        searchTypesCollectionView.dataSource = self
        searchTypesCollectionView.register(UINib(nibName: String(describing: CategoryCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CategoryCell.self))
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
    }
}
extension SearchControl: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCell.self),
                                                          for: indexPath) as! CategoryCell
        categoryCell.configure(name: categories[indexPath.row])
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as? SearchViewController{
            detailVC.searchingType = categories[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

