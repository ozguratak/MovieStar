//
//  RecomModel.swift
//  MovieStar
//
//  Created by obss on 6.06.2022.
//

import Foundation
struct RecomModel: Codable {
    let page: Int?
    let results: [MovieModel]?
}
