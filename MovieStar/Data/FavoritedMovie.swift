//
//  FavoritedMovie.swift
//  MovieStar
//
//  Created by obss on 9.06.2022.
//MARK: - database'e kayıt edilecek verinin yapısı

import Foundation
import RealmSwift

class FavoritedMovie: Object {
    
    @objc dynamic var saveID: Int = 0
    @objc dynamic var saveImage: String = ""
    @objc dynamic var saveTitle: String = ""
    @objc dynamic var saveDate: String = ""
    @objc dynamic var saveRank: Double = 0.0

    }
