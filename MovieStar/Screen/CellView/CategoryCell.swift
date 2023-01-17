//
//  CategoryCell.swift
//  MovieStar
//
//  Created by obss on 17.01.2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(name: String) {
        categoryName.text = name
        imageView.image = UIImage(named: "User-avatar")
    }
}
