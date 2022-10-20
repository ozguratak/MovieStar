//
//  GenreCollectionViewCell.swift
//  MovieStar
//
//  Created by obss on 24.06.2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var genreLabel: UILabel!
    func configure(movie: GenresModel){
        genreLabel.text = movie.name
 }
}
