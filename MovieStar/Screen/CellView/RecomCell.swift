//
//  RecomCell.swift
//  MovieStar
//
//  Created by obss on 24.06.2022.
//

import UIKit
import Kingfisher

class RecomCell: UICollectionViewCell {
    @IBOutlet weak var movieImage: UIImageView! {
        didSet {
            movieImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var movieRank: UILabel! {
        didSet {
            if self.traitCollection.userInterfaceStyle == .dark {
                movieRank.textColor = .black
            } else {
                movieRank.textColor = .black
            }
            movieRank.layer.backgroundColor = .init(red: 222.0, green: 255.1, blue: 0.0, alpha: 0.7)
            movieRank.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var movieName: UILabel!
    func configure(movie: MovieModel) {
        
        movieName.text = movie.title
        movieRank.text = "IMDB: \(String(format: "%.1f", movie.vote_average!))"
        
        if let imagePosterPath = movie.poster_path{
            movieImage.kf.setImage(with: URL(string: Link.poster + imagePosterPath))
        } else {
            movieImage.image = UIImage(named: "404-Image")
        }
    }
}
