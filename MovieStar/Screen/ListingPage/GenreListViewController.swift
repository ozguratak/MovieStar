//
//  GenreListViewController.swift
//  MovieStar
//
//  Created by obss on 10.01.2023.
//

import UIKit

class GenreListViewController: UIViewController {
    var genre: String = ""
    
    private let listingService = ListingServices()
    var movies: [MovieModel] = []
    var newPageContent: [MovieModel] = []
    var page: Int = 1
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: MovieViewCell.self), bundle: nil),
                               forCellReuseIdentifier: String(describing: MovieViewCell.self))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = genre
        Skeleton.startAnimation(outlet: self.tableView)
        listing()
        // Do any additional setup after loading the view.
    }
    
    func listing() {
        listingService.getGenreResults(search: genre) { result in
            switch result {
            case .success(let response):
                self.movies = response.results ?? []
                self.tableView.reloadData()
                Skeleton.stopAnimaton(outlet: self.tableView)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
extension GenreListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieViewCell.self), for: indexPath) as! MovieViewCell
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
            detailVC.idOfMovie = movies[indexPath.row].id //id datası gönderilecek
            self.navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
