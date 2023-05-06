//
//  FirebaseAuthenticationManager.swift
//  MovieStar
//
//  Created by ozgur.atak on 12.04.2023.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit

class FirebaseAuthenticationManager{
    func currentId() -> String {
        return  Auth.auth().currentUser!.uid
    }
    
    func currentUser() -> User? {
        var result: User?
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: keyCurrentUser) {
                result = User.init(_dictionary: dictionary as! NSDictionary)
                return User.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return result
    }
    
    //MARK: - User login, register and logout functions
    
    func loginUser(email: String, password: String, completion: @escaping (_ error: Error?, _ verified: Bool, _ Id: String) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { ( authDataResult, error) in
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    userID = Auth.auth().currentUser!.uid
                    UserDefaults.standard.set(true, forKey: "remindMeSwitch")
                    completion(error, true, userID ?? "")
                } else {
                    authDataResult!.user.sendEmailVerification()
                    userID = Auth.auth().currentUser!.uid
                    if (UserDefaults.standard.value(forKey: "remindMeSwitch") != nil){
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(password, forKey: "password")
                    }
                    completion(error, false, "")
                }
            } else {
                completion(error, false, "")
            }
        }
    }
    
    func registerUser(email: String, password: String, name: String, lastName: String, birthDay: Date, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            completion(error)
            if error == nil {
                User().createUserSet(id: self.currentId(), mail: email, name: name, lastName: lastName, birthday: birthDay)
                authDataResult!.user.sendEmailVerification { error in
                    print("auth e mail verification error : \(String(describing: error))")
                }
                
            } else {
                print("user creating error: \(String(describing: error))")
            }
        }
    }
    
    func logOutUser(page: UIViewController) {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: NSNotification.Name(logOutNotification) , object: nil)
            let mainSb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let appVC = mainSb.instantiateViewController(identifier: "LoginViewController")
            page.show(appVC, sender: self)
        }
        catch {
            ErrorController.alert(alertInfo: "Something get wrong when try to logout!", page: page)
        }
    }
}

extension User {
    func userDictionaryFrom(_ user: User) -> NSDictionary {
        return NSDictionary(objects: [user.mail, user.name, user.lastName, user.birthday, user.comments, user.followersIDs, user.followingIDs, user.objectID], forKeys: [keyUserMail as NSCopying, keyUserName as NSCopying, keyUserLastName as NSCopying, keyUserBirthday as NSCopying, keyUserComments as NSCopying, keyUserFollowers as NSCopying, keyUserFollowing as NSCopying, keyUserID as NSCopying])
    }
    
    func saveUserToFirestore(_ user: User) {
        firebaseReference(.User).document(String(describing: user.objectID!)).setData(userDictionaryFrom(user) as! [String : Any])
    }
    
    func downloadFileFromFirebaseStorage(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        firebaseReference(.User).document("\(id)").getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists else {
                    let error = NSError(domain: "Snapshot does not exist", code: 0, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                
                do {
                    if let data = snapshot.data() {
                        var userData = User(_dictionary: data as NSDictionary)
                        completion(.success(userData))
                    }
                }
            }
    }
    
    func downloadUserFromFirestore(completion: @escaping (_ userArray: [User]) -> Void) {
        
        var userArray: [User] = []
        firebaseReference(.User).getDocuments { snapshot, error in
            guard let snapshot = snapshot
            else {
                completion(userArray)
                return
            }
            
            if !snapshot.isEmpty {
                for usersDict in snapshot.documents {
                    userArray.append(User(_dictionary: usersDict.data() as NSDictionary))
                }
            }
            completion(userArray)
        }
    }
    
    func createUserSet(id: String, mail: String, name: String, lastName: String, birthday: Date) {
        let user = User(_objectId: id, _eMail: mail, _name: name, _lastName: lastName, _birthDay: birthday)
        self.saveUserToFirestore(user)
    }
    
    func updateFollowingList(followUserID: String) {
        firebaseReference(.User).document(userID!).updateData([keyUserFollowers : followUserID]) { error in
            if error != nil {
                print("update error!")
            }
        }
    }
    
    func updateUserInformations(userID: String, name: String, lastName: String, birthday: Date) {
        
        let user = User()
        
        user.birthday = birthday
        user.objectID = userID
        user.mail = currentEmail
        user.name = name
        user.lastName = lastName
        
        self.saveUserToFirestore(user)
    }
    
    enum SocialAction {
        case follower
        case following
    }
    
    enum Action {
        case add
        case delete
    }
    
    func updateFollowers(currentUserID: String, otherUserID: String, type: SocialAction, action: Action) {
        let user = FirebaseAuthenticationManager().currentUser()
        var followers = user?.followersIDs
        var followingIDs = user?.followingIDs
        
        switch type {
        case .follower:
            switch action {
            case .add:
                followersIDs?.append(otherUserID)
            case .delete:
                followersIDs?.remove(at: (followersIDs?.firstIndex(of: otherUserID))!)
            }
            
        case .following:
            switch action {
            case .add:
                followersIDs?.append(otherUserID)
            case .delete:
                followersIDs?.remove(at: (followersIDs?.firstIndex(of: otherUserID))!)
            }
        }
    }
    
    func changePassword(newPassword: String, page: UIViewController) -> Bool{
        let user = User()
        var result: Bool = false
        Auth.auth().currentUser?.reload()
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { error in
            if error == nil {
                ErrorController.alert(alertInfo: "Your password updated succesfully!", page: page)
                UserDefaults.standard.set(newPassword, forKey: "password")
                result = true
            } else {
                ErrorController.alert(alertInfo: "An error occured when try to update your password, please check your password. If you couldnt access your account please contact us!", page: page)
                result = false
            }
        })
        return result
    }
    
    func resendVerifyMail() {
        let user = Auth.auth().currentUser
        user?.reload()
        if user?.isEmailVerified == false {
            user?.sendEmailVerification()
            
        }
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete()
    }
}



