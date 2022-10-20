//
//  MovieDetailModel.swift
//  MovieStar
//
//  Created by obss on 6.06.2022.
//

import Foundation
struct MovieDetailModel: Codable {
    var poster_path: String?
    let backdrop_path: String?
    var title: String?
    var original_title: String?
    var original_language: String?
    var release_date: String?
    var budget: Int?
    var revenue: Int?
    var overview: String?
    var runtime: Int?
    var homepage: String?
    var id: Int?
    var vote_average: Double?
    var genres: [GenresModel]?
    var production_companies: [ProductionCompModel]?
}
struct ProductionCompModel: Codable {
        var name: String?
    }
struct GenresModel: Codable {
    var name: String?
}




