//
//  ProdCollectionViewCell.swift
//  MovieStar
//
//  Created by obss on 24.06.2022.
//

//MARK: - Production Companies Cell
import UIKit

class ProdCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var prodCompLabel: UILabel!
    func configure(movie: ProductionCompModel){
        prodCompLabel.text = movie.name
    }
}
