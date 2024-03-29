//
//  MovieListViewController.swift
//  MovieStar
// 
//  Created by obss on 2.06.2022.
//
//
import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: String(describing: MovieViewCell.self), bundle: nil),
                               forCellReuseIdentifier: String(describing: MovieViewCell.self))
        }
    }
    
    @IBOutlet weak var header: UILabel!{
        didSet{
            header.text = StringKey.listPageHeader
        }
    }
    
  
    private let listingService = ListingServices()
    var movies: [MovieModel] = []
    var newPageContent: [MovieModel] = []
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Skeleton.startAnimation(outlet: self.tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(reload) , name: Notification.Name("FavoritePage"), object: nil)
        listing(page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reload()
    }
    
    @objc func reload(){
        self.tableView.reloadData()
    }
 
}


//MARK: - TableView Control
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1{
            isLoadMore(status: true)
        } else {
            isLoadMore(status: false)
        }
    }
}
//MARK: - Pagination Listing & Control Functions
extension MovieListViewController {
    
    func listing(page: Int){
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
        listingService.getAllMovies(page: page) { result in
            switch result {
            case .success(let response):
                self.movies = response.results ?? []
                self.tableView.reloadData()
                Skeleton.stopAnimaton(outlet: self.tableView)
                self.loadingActivityIndicator.stopAnimating()
                self.loadingActivityIndicator.isHidden = true
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func pagination(page: Int){
        listingService.getAllMovies(page: page) { results in
            switch results {
            case .success(let response):
                self.newPageContent = response.results ?? []
                self.movies.append(contentsOf: self.newPageContent)
                self.tableView.reloadData()
                Skeleton.stopAnimaton(outlet: self.tableView)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isLoadMore(status: Bool) {
        if status {
            loadingActivityIndicator.startAnimating()
            page = page + 1
            pagination(page: page)
        } else {
            loadingActivityIndicator.stopAnimating()
            loadingActivityIndicator.hidesWhenStopped = true
        }
    }
}



