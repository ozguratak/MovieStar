//
//  DataModel.swift
//  MovieStar
//
//  Created by obss on 31.05.2022.
//
// Tüm içerik tmdb.org sitesinden gelen API içeriğine göre modellenmiştir.

import Foundation

struct MovieModel: Codable { // listing page data
    let poster_path: String?
    let backdrop_path: String?
    let title: String?
    let release_date: String?
    let vote_average: Double?
    let id: Int? // critical data (for movie identification number from tmdb)
    let original_title: String?
    let original_language: String?
    let overview: String?
}

