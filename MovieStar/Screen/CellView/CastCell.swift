//
//  CastCell.swift
//  MovieStar
//
//  Created by obss on 24.06.2022.
//

import UIKit

class CastCell: UICollectionViewCell {
    @IBOutlet weak var personImage: UIImageView! {
        didSet{
            personImage.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var personName: UILabel! {
        didSet{
            personName.layer.backgroundColor = .init(red: 222.0, green: 223.0, blue: 249.0, alpha: 0.5)
        }
    }
    
    func configure(movie: Cast) {
        personName.text = movie.name
        if let imagePosterPath = movie.profile_path{
            personImage.kf.setImage(with: URL(string: Link.poster + (imagePosterPath )))
        } else {
            personImage.image = UIImage(named: "User-avatar.svg")
        }
    }
}
