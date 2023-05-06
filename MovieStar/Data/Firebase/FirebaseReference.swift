//
//  FirebaseReference.swift
//  MovieStar
//
//  Created by ozgur.atak on 12.04.2023.
//

import Foundation
import Firebase
import FirebaseFirestore
    enum FCollectionReference: String{
        case User
        case Comment
    }
    
    func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }

