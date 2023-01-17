//
//  ListingServices.swift
//  MovieStar
//
//  Created by obss on 1.06.2022.
// MARK: - Uygulama içerisinde API üzerinden yapılan tüm sorguların fonksiyonlarını düzenlemek ve listelemek için kullanışan sınıftır. 

import Foundation
import UIKit
struct ListingServices {
    
    private let network = Network()
    
    func getAllMovies(page: Int, completion: @escaping (Result <AllMovies, NetworkError>) -> Void ) {
        if let urlString: URL = Link.endpointMaker(endpoint: .list, movieID: nil, page: page, search: nil, idOfPerson: nil, videoID: nil) {
            var urlRequest = URLRequest(url: urlString)
            urlRequest.httpMethod = "GET"
            network.performRequest(request: urlRequest, completion: completion)
        }
    }
    
    func getMovie(idOfMovie: Int, completion: @escaping (Result <MovieDetailModel, NetworkError>) -> Void) {
        if let urlString: URL = Link.endpointMaker(endpoint: .detail, movieID: idOfMovie, page: nil, search: nil, idOfPerson: nil, videoID: nil) {
            var urlRequest = URLRequest(url: urlString )
            urlRequest.httpMethod = "GET"
            network.performRequest(request: urlRequest, completion: completion)
        }
        
        
    }
    func getPerson(idOfMovie: Int, completion: @escaping (Result<CastModel, NetworkError>) -> Void) {
        if let urlString: URL = Link.endpointMaker(endpoint: .credits, movieID: idOfMovie, page: nil, search: nil, idOfPerson: nil, videoID: nil) {
            var urlRequest = URLRequest(url: urlString )
            urlRequest.httpMethod = "GET"
            network.performRequest(request: urlRequest, completion: completion)
        }
    }
    
    func getRecom(idOfMovie: Int, completion: @escaping (Result<RecomModel, NetworkError>) -> Void) {
        if let urlString: URL = Link.endpointMaker(endpoint: .recommend, movieID: idOfMovie, page: nil, search: nil, idOfPerson: nil, videoID: nil) {
            var urlRequest = URLRequest(url: urlString )
            urlRequest.httpMethod = "GET"
            network.performRequest(request: urlRequest, completion: completion)
        }
    }
    
    func getPersonDetail(idOfPerson: Int, completion: @escaping (Result<PersonModel, NetworkError>) -> Void) {
        if let urlString: URL = Link.endpointMaker(endpoint: .personDetail, movieID: nil, page: nil, search: nil, idOfPerson: idOfPerson, videoID: nil) {
            var urlRequest = URLRequest(url: urlString )
            urlRequest.httpMethod = "GET"
            network.performRequest(request: urlRequest, completion: completion)
        }
    }
    
    func getSearchResults(search: String, completion: @escaping (Result<AllMovies, NetworkError>) -> Void) {
        if let urlString: URL = Link.endpointMaker(endpoint: .searchWithMovie, movieID: nil, page: nil, search: search, idOfPerson: nil, videoID: nil){
            var urlRequest = URLRequest(url: urlString )
            urlRequest.httpMethod = "GET"
            network.performRequest(request: urlRequest, completion: completion)
        }
    }
    
    func getGenreResults(search: String, completion: @escaping (Result<AllMovies, NetworkError>) -> Void) {
        if let urlString: URL = Link.endpointMaker(endpoint: .genre, movieID: nil, page: nil, search: search, idOfPerson: nil, videoID: nil){
            var urlRequest = URLRequest(url: urlString)
            urlRequest.httpMethod = "GET"
            network.performRequest(request: urlRequest, completion: completion)
        }
    }
    
    func getYoutubeVideoID(search: String, completion: @escaping (Result<YoutubeModel, NetworkError>) -> Void) {
        if let urlString: URL = Link.endpointMaker(endpoint: .youtube, movieID: nil, page: nil, search: search, idOfPerson: nil, videoID: nil) {
            var urlRequest = URLRequest(url: urlString)
            urlRequest.httpMethod = "GET"
            network.performRequest(request: urlRequest, completion: completion)
        }
    }
}


