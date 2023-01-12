//
//  DatabaseManager.swift
//  MovieStar
//
//  Created by obss on 10.06.2022.
//MARK: - içeriklerin favorilenmesi sürecinde gerek duyulan database CRUD işlemlerinin toplandığı sınıftır. Sınıf içerisinde realm kabuğu kullanılarak ekleme, silme güncelleme ve okuma işlemleri yönetilir. 

import Foundation
import SwiftUI
import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    let listingService = ListingServices()
    
    private var updateList: [Int] = []
    private var movieList: Array? = []
    lazy var realm: Realm = {
        return try! Realm()
    }()
    var movieID: Int?
}
//MARK: - DB'ye veri ekleme silme ve ekli olma durumu kontrol fonksiyonları
extension DatabaseManager {
    
    func save(movieID: Int, image: String, title: String, date: String, rank: Double ) { // DB'ye id ekleme
        do {
            try realm.write {
                let favoriteMovie = FavoritedMovie()
                favoriteMovie.saveID = movieID
                favoriteMovie.saveImage = image
                favoriteMovie.saveTitle = title
                favoriteMovie.saveDate = date
                favoriteMovie.saveRank = rank
                realm.add(favoriteMovie)
                NotificationCenter.default.post(name: Notification.Name("FavoritePage"), object: nil)
            }
        } catch { //eklenemezse kullanıcıya uyarı ver
            print("An error occurred while saving the category: \(error)")
        }
    }
    
    func delete(movieID: Int) { //dbden id kaldırma
        do {
            let ID = realm.objects(FavoritedMovie.self).filter("saveID = %@", movieID).first
            try realm.write {
                if let id = ID{
                    realm.delete(id)
                    realm.refresh()
                    NotificationCenter.default.post(name: Notification.Name("FavoritePage"), object: nil)
                }
            }
        } catch {
            print("An error occured while deleting object \(error)")
        }
    }
    
    func checkStatus(movieID: Int) -> Bool? { // dbde verinin ekli olması durumunda true döner
        var intID: [Int?] = []
        let allMovies = realm.objects(FavoritedMovie.self)
        for moVies in allMovies{
            let saveID = moVies.saveID
            let integerID = Int(saveID)
            intID.append(integerID)
        }
        return intID.contains(movieID)
    }
    
    func readMovie() -> [FavoritedMovie] { // obj olan dbyi array olarak alıyor
        let allMovies = realm.objects(FavoritedMovie.self)
        return Array(allMovies)
    }
    
    func updateDB(){ // Database içeriğini id referanslı güncelleme fonksiyonu. default hatası; API'den gelen id değişirse patlar.
        let allMovies = realm.objects(FavoritedMovie.self)
        updateList.removeAll()
        for moVies in allMovies{
            let saveID = moVies.saveID
            let integerID = Int(saveID)
            delete(movieID: integerID)
            updateList.append(integerID)
        }
        for integerID in updateList{
            reload(IDs: integerID)
        }
    }
    
    func reload(IDs: Int){
        listingService.getMovie(idOfMovie: IDs) { result in
            switch result {
            case .success(let updatedmovie):
                self.save(movieID: updatedmovie.id ?? IDs,
                          image: updatedmovie.poster_path ?? "",
                          title: updatedmovie.title ?? "",
                          date: updatedmovie.release_date ?? "",
                          rank: updatedmovie.vote_average ?? 0)
                if self.updateList.count == self.readMovie().count {
                    NotificationCenter.default.post(name: Notification.Name("ReloadEnd"), object: nil)
                }
            case .failure(let error):
                print("update error: \(error)")
            }
        }
    }
}
