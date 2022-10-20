//
//  Links.swift
//  MovieStar
//
//  Created by obss on 1.06.2022.
//MARK: - Kullanılan veritabanının API linklerinin sıralandığı listedir. 

import Foundation

struct EndpointList{
    static let list = "3/movie/popular"
    static let detail = "3/movie/"
    static let credits = "/credits"
    static let recommend = "/recommendations"
    static let personDetail = "3/person/"
    static let cast = "/movie_credits"
    static let search = "3/search/movie"
    static let page = "&page="
    static let query = "&query="
}
struct Link {
    private static let language = "&language=\(Locale.current.languageCode!)"
    private static let base = "https://api.themoviedb.org/"
    private static let api = "?api_key=0c8be20e0f5be9d2bd79558265fc47c0"
    static let poster = "https://image.tmdb.org/t/p/w500"
    private static let endpoints = EndpointList.self
    
    
    static func endpointMaker(endpoint: Endpoints, movieID: Int?, page: Int?, search: String?, idOfPerson: Int?) -> URL? {
        var makedURL: URL? = URL(string: "")
        switch endpoint {
        case .list:
            makedURL = URL(string: Link.base + endpoints.list + Link.api + Link.language + endpoints.page + "\(page ?? 0)")
        case .detail:
            makedURL = URL(string: Link.base + endpoints.detail + "\(movieID ?? 0)" + Link.api + Link.language)
        case .searching:
            makedURL = URL(string: Link.base + endpoints.search + Link.api + endpoints.query + "\(search ?? "")")
        case .personDetail:
            makedURL = URL(string: Link.base + endpoints.personDetail + "\(idOfPerson ?? 0)" + Link.api + Link.language)
        case .recommend:
            makedURL = URL(string: Link.base + endpoints.detail + "\(movieID ?? 0)" + endpoints.recommend + Link.api)
        case .credits:
            makedURL = URL(string: Link.base + endpoints.detail + "\(movieID ?? 0)" + endpoints.credits + Link.api)
        default:
            print("endpointmaker error")
        }
        return makedURL!
    }
}


enum Endpoints{
    case list
    case detail
    case credits
    case recommend
    case personDetail
    case cast
    case searching
    case query
}


