//
//  CommentModels.swift
//  MovieStar
//
//  Created by ozgur.atak on 11.04.2023.
//

import Foundation

class CommentModel {
    var movieID: Int?
    var commentID: String?
    var userName: String?
    var userLastName: String?
    var userID: String?
    var date: String?
    var comment: String?
    
    @available(iOS 15, *)
    init (_date: String, _movieID: Int, _commentId: String, _comment: String, _name: String, _lastname: String, _userID: String) {
        movieID = _movieID
        commentID = _commentId
        comment = _comment
        date = _date
        userName = _name
        userID = _userID
        userLastName = "\(_lastname.first?.uppercased() ?? "Last Name")."
    }
    
    init (_dictionary: NSDictionary) {
        userID = _dictionary[keyCommentUserID] as? String
       
        if let name = _dictionary[keyCommentOwnerName] as? String {
            userName = name
        } else {
            userName = "Unknown"
        }
        
        if let lastName = _dictionary[keyCommentOwnerLastName] as? String {
            userLastName = lastName.first?.uppercased()
        } else {
            userLastName = "User"
        }
        
        if let commentDate = _dictionary[keyCommentDate] as? String {
            
            date = commentDate
        } else {
            date = String(describing: Date().timeIntervalSinceNow)
        }
        
        if let ID = _dictionary[keyCommentMovieID] as? Int {
            movieID = ID
        } else {
            movieID = 0
        }
        
        if let text = _dictionary[keyCommentText] as? String {
            comment = text
        } else {
            comment = "Comment couldn't find or empty."
        }
    }
}
