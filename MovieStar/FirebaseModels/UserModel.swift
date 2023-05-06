//
//  UserModel.swift
//  MovieStar
//
//  Created by ozgur.atak on 11.04.2023.
//

import Foundation

class User{
    var objectID: String?
    var name: String?
    var lastName: String?
    var birthday: Date?
    var followersIDs: [String]?
    var followingIDs: [String]?
    var mail: String?
    var comments: [CommentModel]?
    
    init () {
    }
    
    init (_objectId: String, _eMail: String, _name: String, _lastName: String, _birthDay: Date) {
        
        objectID = _objectId
        mail = _eMail
        name = _name
        lastName = _lastName
        birthday = _birthDay
        followersIDs = []
        comments = []
        followingIDs = []
    }
    
    init (_dictionary: NSDictionary) {
        
        name = _dictionary[keyUserName] as? String ?? "User Name"
        lastName = _dictionary[keyUserLastName] as? String ?? "User Lastname"
        birthday = _dictionary[keyUserBirthday] as? Date ?? ._createNil
        
        if let comment = _dictionary[keyUserComments] {
            comments = comment as? [CommentModel] ?? []
        } else {
            comments = []
        }
        
        if let followers = _dictionary[keyUserFollowers] {
            followersIDs = followers as? [String] ?? []
        } else {
            followersIDs = []
        }
        
        if let followings = _dictionary[keyUserFollowing] {
            followingIDs = followings as? [String] ?? []
        } else {
            followingIDs = []
        }
        
    }
}
