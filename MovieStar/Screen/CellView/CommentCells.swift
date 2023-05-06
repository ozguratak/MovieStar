//
//  CommentCells.swift
//  MovieStar
//
//  Created by ozgur.atak on 13.04.2023.
//

import UIKit

class CommentCells: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(comment: CommentModel) {
        if let comment = comment.comment {
            commentLabel.text = comment
        } else {
            commentLabel.text = "Not found."
        }
        
        if let userName = comment.userName, let lastName = comment.userLastName {
            userNameLabel.text = "\(userName) \(lastName.first?.uppercased() ?? "X")."
        } else {
            userNameLabel.text = "Guest Comment"
        }
        
        if let date = comment.date {
            dateLabel.text = date
        } else {
            dateLabel.text = " - "
        }
        
        dateLabel.text = String(describing: Date().timeIntervalSinceNow)
        
    }
}
