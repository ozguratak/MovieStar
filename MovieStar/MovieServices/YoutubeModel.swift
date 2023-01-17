//
//  YoutubeModel.swift
//  MovieStar
//
//  Created by obss on 16.01.2023.
//

import Foundation

struct YoutubeModel: Codable {
    let items: [Item]
}

struct Item: Codable {
    let id: Id
}

struct Id: Codable {
    let videoId: String
}


