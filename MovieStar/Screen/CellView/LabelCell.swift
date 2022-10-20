//
//  LabelCell.swift
//  MovieStar
//
//  Created by obss on 24.06.2022.
//

import UIKit

class LabelCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    func configureGenres(model: GenresModel) {
        textLabel.text = model.name
    }
    
    func configureProd(model: ProductionCompModel) {
        textLabel.text = model.name
    }

}
