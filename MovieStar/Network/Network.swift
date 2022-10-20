//
//  Network.swift
//  RickAndMortyApp
//
//  Created by obss on 14.05.2022.
//MARK: - Decoding işlemleri için kullanılan perform request fonksiyonu için yapılmış sınıftır.

import Foundation
struct Network {
    private let session = URLSession.shared
    func performRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void ) {
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data { // eğer data geldiyse
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(model))
                    }
                    catch { // hata yakala
                        completion(.failure(.decodingError))
                    }
                }
                else if error != nil {
                    completion(.failure(.sessionError))
                }
                else {
                    completion(.failure(.unknownError))
                }
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case decodingError
    case sessionError
    case unknownError
    case URLError
}

