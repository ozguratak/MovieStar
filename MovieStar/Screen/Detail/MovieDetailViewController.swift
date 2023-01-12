//
//  MovieDetailViewController.swift
//  MovieStar
//
//  Created by obss on 2.06.2022.
//
//MARK: - detay sayfası kontrolörü; uygulamanının en yoğun sayfası, cast, yapım şirketi ve filme ait bütün detayların listelendiği sayfadır. tüm uygulama içerisinde gezinme imkanı sunar, filmin websitesi, favori ekleme kaldırma ve favori sayfasına gitme, oyuncu detaylarını görüntüleme ve benzer filmleri görüntüleyip detaylarına ilerleme gibi özellikleri sunar. 
import UIKit
import Foundation
import Kingfisher
import SkeletonView

class MovieDetailViewController: UIViewController {
     
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var originalTitleLanguage: UILabel!
    @IBOutlet weak var releaseDateRuntime: UILabel!
    @IBOutlet weak var budgetRevenue: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var OrgLanguage: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet weak var homepagebutton: UIButton!{
        didSet{
            homepagebutton.setImage(UIImage(systemName: "link"), for: .normal)
            homepagebutton.titleLabel?.isHidden = true
        }
    }
    @IBOutlet weak var castCollectionView: UICollectionView! {
        didSet {
            castCollectionView.dataSource = self
            castCollectionView.delegate = self
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            castCollectionView.register(UINib(nibName: String(describing: CastCell.self), bundle: nil),
                                        forCellWithReuseIdentifier: String(describing: CastCell.self))
        }
    }
    @IBOutlet weak var recomCollectionView: UICollectionView! {
        didSet {
            recomCollectionView.dataSource = self
            recomCollectionView.delegate = self
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            recomCollectionView.register(UINib(nibName: String(describing: RecomCell.self), bundle: nil),
                                         forCellWithReuseIdentifier: String(describing: RecomCell.self))
        }
    }
    @IBOutlet weak var genresCollectionView: UICollectionView! {
        didSet {
            genresCollectionView.dataSource = self
            genresCollectionView.delegate = self
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            genresCollectionView.register(UINib(nibName: String(describing: LabelCell.self), bundle: nil),
                                          forCellWithReuseIdentifier: String(describing: LabelCell.self))
        }
    }
    @IBOutlet weak var prodCompCollectionView: UICollectionView! {
        didSet {
            prodCompCollectionView.register(UINib(nibName: String(describing: LabelCell.self), bundle: nil),
                                            forCellWithReuseIdentifier: String(describing: LabelCell.self))
            prodCompCollectionView.dataSource = self
            prodCompCollectionView.delegate = self
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            
           
        }
    }
    @IBOutlet var collectionOfView: Array<UIView> = []
    
    @IBOutlet weak var prodCompTitle: UILabel!{
        didSet{
            
            prodCompTitle.text = StringKey.prodTitle
           
        }
    }
    @IBOutlet weak var genresTitle: UILabel!{
        didSet{
            genresTitle.text = StringKey.genreTitle
  
        }
    }
    @IBOutlet weak var infoTitle: UILabel!{
        didSet{
            infoTitle.text = StringKey.infoTitle
        }
    }
    @IBOutlet weak var castTitle: UILabel!{
        didSet{
            
            castTitle.text = StringKey.castTitle
         
        }
    }
    @IBOutlet weak var recomTitle: UILabel!{
        didSet{
            
            recomTitle.text = StringKey.recomTitle
          
        }
    }
    private let label = UILabel()
    private let dbmanager = DatabaseManager.shared
    private let error = ErrorController.self
    private let listingService = ListingServices()
    var idOfMovie: Int?
    private var castList: [Cast] = []
    private var recomList: [MovieModel] = []
    private var genresList: [GenresModel] = []
    private var prodList: [ProductionCompModel] = []
    private var favMovie: FavoritedMovie?
    private var movie: MovieDetailModel? {
        didSet {
           
            title = movie?.title
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCheck()
        if let id = idOfMovie {  //dışarıdan aldığım veriye göre işlem yap veri liste ekranından geliyor. gelen veri formatı Int?
            
            listingService.getMovie(idOfMovie: id) { result in // filmi listele
                switch result {
                case .success(let newMovie):
                    self.movie = newMovie
                    self.genresList = newMovie.genres ?? []
                    self.genresCollectionView.reloadData()
                    self.prodList = newMovie.production_companies ?? []
                    self.prodCompCollectionView.reloadData()
                    Skeleton.stopAnimationArray(outlets: self.collectionOfView)
                    self.updateUI()
                case .failure(let error):
                    print(error)
                }
            }
            
            listingService.getPerson(idOfMovie: id) { results in // oyuncularını listele
                switch results {
                case .success(let response):
                    self.castList = response.cast ?? []
                    self.castCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
            
            listingService.getRecom(idOfMovie: id) { result in // recom listele
                switch result {
                case .success(let result):
                    self.recomList = result.results ?? []
                    self.recomCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
            
        } else { // id verisi gelmedi ekrana hata bastım
            error.alert(alertInfo: StringKey.noMovie, page: self)
        }
        //sayfa içerikleri skeleton başlat
        
        Skeleton.startAnimationArray(outlets: collectionOfView)
       
    }
    
 

    //MARK: - Film detayı içeriği setleme, içeriklerin optionaldan çıkartılması hata fırlatma
    func updateUI() {
        
        if let imagePosterPath = movie?.backdrop_path{
            movieImage.kf.setImage(with: URL(string: Link.poster + imagePosterPath))
        } else {
            movieImage.image = UIImage(named: "404-Image")
        }
        
        if let overView = movie?.overview {
            if !overView.isEmpty {
                overview.text = "\(StringKey.overview) \(overView)"
                
            } else {
                overview.text = StringKey.noOverview
            }
        } else {
            return overview.text! = StringKey.noOverview
        }
        
        if let orgLang = movie?.original_language {
            if !orgLang.isEmpty{
                OrgLanguage.text = StringKey.orgLang + getLanguage(code: orgLang)
            } else {
                OrgLanguage.text = StringKey.unLanguage
            }
        } else {
            return OrgLanguage.text = StringKey.unLanguage
        }
        
        if let orgTitle = movie?.original_title {    //switch case e girecek
            if !orgTitle.isEmpty{
                originalTitleLanguage.text = StringKey.orgTitle + "\(orgTitle)"
            } else {
                originalTitleLanguage.text = StringKey.unTitle
            }
        }else{
            return originalTitleLanguage.text = StringKey.unTitle
        }
        
        if let release = movie?.release_date {
            if !release.isEmpty{
                releaseDateRuntime.text = StringKey.releaseDate + "\(release)"
            } else {
                releaseDateRuntime.text = StringKey.unRelease
            }
        } else {
            return releaseDateRuntime.text = StringKey.unRelease
        }
        
        if let budget = movie?.budget {
            if budget >= (1) {
                let curRency = String(describing: budget).toCurrencyFormat()
                if !curRency.isEmpty {
                    budgetRevenue.text = StringKey.budget  + "\(curRency)"
                } else {
                    budgetRevenue.text = StringKey.budget + StringKey.unValue
                }
            } else {
                budgetRevenue.text = StringKey.budget + StringKey.unValue
            }
        } else {
            return budgetRevenue.text = StringKey.unBudget
        }
        
        if let revEnue = movie?.revenue {
            if revEnue > 0 {
                let currency = String(describing: revEnue).toCurrencyFormat()
                if !currency.isEmpty{
                    revenue.text = StringKey.revenue + "\(currency)"
                } else {
                    revenue.text = StringKey.revenue + StringKey.unValue
                }
            } else {
                revenue.text = StringKey.revenue + StringKey.unValue
            }
            
        } else {
            return revenue.text = StringKey.unRevenue
        }
        
        if let runTime = movie?.runtime {
            if !runTime.words.isEmpty {
                runtime.text = StringKey.runtime + "\(runTime)" + StringKey.minute
            } else {
                runtime.text = StringKey.unRuntime
            }

        } else {
            return runtime.text = StringKey.unRuntime
        }
       
        
    }
    
    //MARK: - Homepage buton aktivitesi
    @IBAction func homepageButtonPressed(_ sender: UIButton) {
        if let webpageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: WebpageViewerViewController.self)) as? WebpageViewerViewController{
            webpageVC.link = URL(string: (movie?.homepage)!)//homepage string datası gönderilecek
            self.navigationController?.pushViewController(webpageVC, animated: true)
        }
    }
    //MARK: - Gösterim için favori durumu kontrol ve gösterme
    func favoriteCheck() {
        if let idOfMovie = idOfMovie {
            if dbmanager.checkStatus(movieID: idOfMovie) == true {
                buttonState.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
                buttonState.titleLabel?.isHidden = true
            } else {
                buttonState.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
                buttonState.titleLabel?.isHidden = true
            }
        }
    }
    //MARK: -Favori ekleme butonu aktivitesi
    @IBAction func addFavoritePressed(_ sender: UIButton) {
        if let idOfMovie = idOfMovie {
            if dbmanager.checkStatus(movieID: idOfMovie) == false {
                dbmanager.save(movieID: idOfMovie,
                               image:(movie?.poster_path ?? String(describing: UIImage(named: "404-Image"))),
                               title: (movie?.title ?? StringKey.unName),
                               date: (movie?.release_date ?? StringKey.unknownRelease),
                               rank: (movie?.vote_average ?? 0.0))
                iconSet(iconName: "heart.fill")
            } else { // BU ALARM ERRORCONTROLLERA GİDECEK!
                ErrorController.alert2Button(alertInfo: StringKey.favoriteButtonAlert,
                                             page: self, button1: StringKey.ok, button2: StringKey.remove, movieID: idOfMovie)
                iconSet(iconName: "heart")
            }
        } else { // id of movie hatalı geldiyse veya nilse error göster
            error.alert(alertInfo: StringKey.favError, page: self)
        }
    }
    func iconSet(iconName: String){
        buttonState.setImage(UIImage(systemName: iconName), for: UIControl.State.normal)
        buttonState.titleLabel?.isHidden = true
        
    }
}
//MARK: - Cast & Recom Collection view controllers
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.castCollectionView:
            let cellCast = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CastCell.self),
                                                              for: indexPath) as! CastCell
            cellCast.configure(movie: castList[indexPath.row])
            return cellCast
            
        case self.recomCollectionView:
            let cellRecom = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecomCell.self),
                                                               for: indexPath) as! RecomCell
            cellRecom.configure(movie: recomList[indexPath.row])
            return cellRecom
            
        case self.genresCollectionView:
            let cellGenres = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LabelCell.self),
                                                                for: indexPath) as! LabelCell
            cellGenres.configureGenres(model: genresList[indexPath.row])
            return cellGenres
            
        default:
            let cellProd = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LabelCell.self),
                                                              for: indexPath) as! LabelCell
            cellProd.configureProd(model: prodList[indexPath.row])
            return cellProd
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "LabelCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case self.castCollectionView:
            return castList.count
        case self.genresCollectionView:
            return genresList.count
        case self.prodCompCollectionView:
            return prodList.count
        default:
            return recomList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
        case self.genresCollectionView:
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: GenreListViewController.self)) as? GenreListViewController {
                detailVC.genre = genresList[indexPath.row].name ?? ""
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        case self.castCollectionView:
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
                withIdentifier: String(describing: PersonDetailViewController.self)) as? PersonDetailViewController {
                detailVC.idOfPerson = castList[indexPath.row].id
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        case self.recomCollectionView:
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
                withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController {
                detailVC.idOfMovie = recomList[indexPath.row].id
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        default:
            return
        }
    }
}

