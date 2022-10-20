//
//  PersonModel.swift
//  MovieStar
//
//  Created by obss on 15.06.2022.
//

import Foundation
struct PersonModel: Codable {
    var biography: String?
    var birthday: String?
    var deathday: String?
    var id: Int?
    var name: String
    var place_of_birth: String?
    var profile_path: String?
}
