//
//  MovieViewCell.swift
//  MovieStar
//
//  Created by obss on 2.06.2022.
//

import UIKit
import Kingfisher

class MovieViewCell: UITableViewCell {
    let dbmanager = DatabaseManager.init()
    @IBOutlet weak var rankLabel: UILabel!{
        didSet{
            rankLabel.layer.backgroundColor = .init(red: 222.0, green: 255.1, blue: 0.0, alpha: 0.7)
        }
    }
    @IBOutlet weak var moviePoster: UIImageView! {
        didSet {
            moviePoster.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var favoriteCheck: UIImageView!
    

    func configure(movie: MovieModel) {
        if let rank = movie.vote_average{
            rankLabel.text = "IMDB: \(String(format: "%.1f", rank))"
        } else {
            rankLabel.text = StringKey.notRanked
        }
        titleLabel.text = movie.title?.localized()
        releaseDate.text = movie.release_date?.localized()
        let posterPathURL = URL(string: Link.poster + "\(movie.poster_path ?? "")")
        moviePoster.kf.setImage(with: posterPathURL)
        if dbmanager.checkStatus(movieID: movie.id ?? 0) == true{
               favoriteCheck.image = UIImage.init(systemName: "heart.fill")
           } else {
               favoriteCheck.image = nil
           }
    }
   
}
