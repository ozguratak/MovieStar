//
//  SearchViewController.swift
//  MovieStar
//
//  Created by obss on 2.06.2022.
//
// MARK: - Arama sayfası arama barına yazılan texti gerekli kontrol bloğundan süzdükten sonra arama yapmak için API sorgusuna çıkar gelen sonuçları 2 sn bekledikten sonra kullanıcıya listeler. kullanıcının aradığını bulması durumund ailgili içeriğin detay sayfasına yönlendirir.
import UIKit

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var header: UILabel!{
        didSet{
            header.text = StringKey.searchPageHeader
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.text = StringKey.searchMessage
        }
    }
    var searchingType: String = ""
    private var searchingText: String = ""
    private var searchResults: [MovieModel] = []
    private let listingService = ListingServices()
    private let searchController = UISearchController()
    private var searchtext: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: MovieViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: MovieViewCell.self)) //benim tanımaldığım hücre yapısını register et.
        searchBar.delegate = self
        Skeleton.hideMessage(parentView: tableView, childView: messageLabel, state: true)
        hideKeyboardWhenTappedAround()
    }
}

//MARK: - Tableview configurations
extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieViewCell.self), for: indexPath) as! MovieViewCell
        
        cell.configure(movie: searchResults[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
            if let iDOfMovie = searchResults[indexPath.row].id{
                detailVC.idOfMovie = iDOfMovie//id datası gönderilecek
                self.navigationController?.pushViewController(detailVC, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                ErrorController.alert(alertInfo: StringKey.noDetail, page: self)
            }
        }
    }
}

//MARK: -Listing Functions
extension SearchViewController {
        func searchItem(text: String) {
            listingService.getSearchResults(search: text) { result in
                switch result {
                case .success(let response):
                    self.searchResults = response.results ?? []
                    if self.searchResults.count >= 1 {
                        self.tableView.reloadData()
                    } else {
                        ErrorController.alert(alertInfo: "\(StringKey.notFound) \(self.searchingText)" , page: self)
                    }
                    
                    if self.searchResults.count > 0 {
                    Skeleton.stopAnimaton(outlet: self.tableView)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

//MARK: - Searchbar controllers
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if searchBar.text?.isEmpty == true || searchBar.text == "" {
            searchResults.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            Skeleton.hideMessage(parentView: tableView, childView: messageLabel, state: true)
        }
        
        let correctedText = characterCheck(text: searchText)
        self.searchingText = searchText
        
        let bottomOffset = CGPoint(x: 0, y: 0)
        tableView.setContentOffset(bottomOffset, animated: true)
        if searchText.count >= 1{
            Skeleton.hideMessage(parentView: tableView, childView: messageLabel, state: false)
            Skeleton.startAnimation(outlet: tableView)
            searchItem(text: correctedText.replaceSpaces())
        } else {
            Skeleton.stopAnimaton(outlet: tableView)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        self.searchtext.removeAll()
        Skeleton.hideMessage(parentView: tableView, childView: messageLabel, state: true)
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchController.automaticallyShowsSearchResultsController = true
    }
    
    func characterCheck(text: String) -> String { // ascii-7 olmayan karakterlerin düzeltilmesi
        var correctedText: String = ""
        for ch in text {
            if ch.isASCII == true {
                correctedText += ch.description.lowercased()
            } else {
                correctedText += ch.description.urlEncoded ?? ""
            }
        }
        return correctedText
    }
}




