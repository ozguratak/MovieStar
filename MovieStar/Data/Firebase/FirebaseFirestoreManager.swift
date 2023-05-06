//
//  FirebaseFirestoreManager.swift
//  MovieStar
//
//  Created by ozgur.atak on 12.04.2023.
//

import Foundation

class FirebaseCommentManager {
    
    func commentDictionaryFrom(_ comment: CommentModel) -> NSDictionary {
        return NSDictionary(objects: [comment.commentID!, comment.movieID!, comment.userName!, comment.userLastName!, comment.comment ?? ""], forKeys: [keyCommentID as NSCopying, keyCommentMovieID as NSCopying, keyCommentOwnerName as NSCopying, keyCommentOwnerLastName as NSCopying, keyCommentText as NSCopying])
    }
    
    func saveCommentToFirestore(_ comment: CommentModel) {
        firebaseReference(.Comment).document(comment.commentID!).setData(commentDictionaryFrom(comment) as! [String : Any])
    }
    
    func downloadCommentsFromFirestore(completion: @escaping (_ commentArray: [CommentModel]) -> Void) {
        
        var commentArray: [CommentModel] = []
        firebaseReference(.Comment).getDocuments { snapshot, error in
            guard let snapshot = snapshot
            else {
                completion(commentArray)
                return
            }
            
            if !snapshot.isEmpty {
                for commentDict in snapshot.documents {
                    var comment = CommentModel(_dictionary: commentDict.data() as [String : Any] as NSDictionary)
                    commentArray.append(comment)
                }
                completion(commentArray)
            }
        }
    }
    
    @available(iOS 15, *)
    func createCommentSet(date: String, movieID: Int, commentID: String, comment: String, name: String, lastName: String) {
        
        let comment = CommentModel(_date: date, _movieID: movieID, _commentId: commentID, _comment: comment, _name: name, _lastname: lastName, _userID: userID!)
        self.saveCommentToFirestore(comment)
    }
    
}
