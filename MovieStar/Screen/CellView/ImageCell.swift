//
//  ImageCell.swift
//  MovieStar
//
//  Created by obss on 16.01.2023.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {


    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(link: URL?){
        if let image = link {
            imageView.kf.setImage(with: image)
        } else {
            imageView.image = UIImage(named: "404-Image")
        }
        
    }
    
}
