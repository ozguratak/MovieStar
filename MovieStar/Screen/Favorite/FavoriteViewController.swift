//
//  FavoriteViewController.swift
//  MovieStar
//
//  Created by obss on 9.06.2022.
//
//MARK: - Favori Sayfası Kontrolörü; kullanıcının uygulama içerisinde cihaz belleğine kayıt ettiği içeriklerin listelenmesi ve silinmesi özelliklerini kontrol eder. aynı zamanda sayfa boşken kullanıcıya boş ekran yerine bilgilendirme mesajı sunulur. 
import UIKit
import Foundation
import Kingfisher

class FavoriteViewController: UIViewController {
    static let shared = FavoriteViewController()  // KALKACAK!!!!
    
    private let dbmanager = DatabaseManager.init()
    private var movieList = [FavoritedMovie]()
    private let refreshControl = UIRefreshControl()
    let link = Link()
    
    @IBOutlet weak var header: UILabel!{
        didSet{
            header.text = StringKey.favoritesPageHeader
        }
    }
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.text = StringKey.favoriteEmpty
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = StringKey.favoritesPageHeader
        NotificationCenter.default.addObserver(self, selector: #selector(updateList) , name: Notification.Name("FavoritePage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateList) , name: Notification.Name("ReloadEnd"), object: nil)
        updateList()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: MovieViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: MovieViewCell.self))
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized())
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func updateList() {
        movieList.removeAll()
        movieList.append(contentsOf: dbmanager.readMovie())
        Skeleton.hideMessage(parentView: tableView, childView: messageLabel, state: movieList.isEmpty)
        refreshControl.endRefreshing()
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Skeleton.stopAnimaton(outlet: self.tableView)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Skeleton.startAnimation(outlet: self.tableView)
        movieList.removeAll()
        dbmanager.updateDB()
        updateList()
    }
}
// MARK: - Sayfa düzenlemesi ile ilgili fonksiyonlar
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    //Edit için hazır bir fonksiyon
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    //TableView içini editleyebilmemiz için bir hazır fonksiyon daha
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dbmanager.delete(movieID: movieList[indexPath.row].saveID)
            updateList()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbmanager.readMovie().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieViewCell.self), for: indexPath) as! MovieViewCell
        cell.titleLabel?.text = movieList[indexPath.row].saveTitle // film başlığı
        let imagePath = URL(string: Link.poster + "\(movieList[indexPath.row].saveImage)") //image path
        cell.moviePoster.kf.setImage(with: imagePath) // resim
        cell.releaseDate.text = movieList[indexPath.row].saveDate // release date
        cell.rankLabel.text = "IMDB: \(String(format: "%.1f", movieList[indexPath.row].saveRank))"  //puan
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
            detailVC.idOfMovie = movieList[indexPath.row].saveID
            self.navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


