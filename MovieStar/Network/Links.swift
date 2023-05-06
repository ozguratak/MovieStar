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
    static let searchWithMovieName = "3/search/movie"
    static let searchWithPerson = "3/search/person"
    static let page = "&page="
    static let query = "&query="
    static let genre = "&with_genres="
    static let discover = "3/discover/movie"
    
}
struct Youtube {
    static let apikey = "&key=AIzaSyAOtY3xPR3X6avT2YlWyIB3cX6wbiQ1hC8"
    static let baseLink = "https://www.googleapis.com/youtube/v3/"
    static let search = "search?part=snippet&q="
    static let watchLink = "https://www.youtube.com/embed/"
    static let autoPlay = "?playsinline=1&autoplay=1"
}

struct Link {
    private static let language = "&language=\(Locale.current.languageCode!)"
    private static let base = "https://api.themoviedb.org/"
    private static let api = "?api_key=0c8be20e0f5be9d2bd79558265fc47c0"
    static let poster = "https://image.tmdb.org/t/p/w500"
    private static let endpoints = EndpointList.self
    
    
    static func endpointMaker(endpoint: Endpoints, movieID: Int?, page: Int?, search: String?, idOfPerson: Int?, videoID: String?) -> URL? {
        var makedURL: URL? = URL(string: "")
        switch endpoint {
        case .list:
            makedURL = URL(string: Link.base + endpoints.list + Link.api + Link.language + endpoints.page + "\(page ?? 0)")
        case .detail:
            makedURL = URL(string: Link.base + endpoints.detail + "\(movieID ?? 0)" + Link.api + Link.language)
        case .searchWithMovie:
            makedURL = URL(string: Link.base + endpoints.searchWithMovieName + Link.api + endpoints.query + "\(search ?? "")")
        case .searchWithPerson:
            makedURL = URL(string: Link.base + endpoints.searchWithPerson + Link.api + endpoints.query + "\(search ?? "")")
        case .personDetail:
            makedURL = URL(string: Link.base + endpoints.personDetail + "\(idOfPerson ?? 0)" + Link.api + Link.language)
        case .recommend:
            makedURL = URL(string: Link.base + endpoints.detail + "\(movieID ?? 0)" + endpoints.recommend + Link.api)
        case .credits:
            makedURL = URL(string: Link.base + endpoints.detail + "\(movieID ?? 0)" + endpoints.credits + Link.api)
        case .genre:
            makedURL = URL(string: Link.base + endpoints.discover + Link.api + endpoints.genre + "\(search ?? "")")
        case .youtube:
            makedURL = URL(string: Youtube.baseLink + Youtube.search + "\(search ?? "")" + StringKey.trailer + Youtube.apikey)
        case .watch:
            makedURL = URL(string: Youtube.watchLink + "\(videoID ?? "")" + Youtube.autoPlay)
        default:
            print("endpointmaker error")
        }
        print(makedURL)
        return makedURL
    }
}


enum Endpoints{
    case list
    case detail
    case credits
    case recommend
    case personDetail
    case cast
    case searchWithMovie
    case searchWithPerson
    case query
    case genre
    case youtube
    case watch
}


