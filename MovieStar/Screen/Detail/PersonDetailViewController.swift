//
//  PersonDetailViewController.swift
//  MovieStar
//
//  Created by obss on 15.06.2022.
//
//MARK: - detay sayfası üzerinden yönlendirilen bir sayfadır. film oyuncularının bilgilerini sunar. 

import UIKit
import Kingfisher

class PersonDetailViewController: UIViewController {
    @IBOutlet weak var personImage: UIImageView! {
        didSet {
            personImage.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var deathday: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var personalNameLabel: UILabel!
    @IBOutlet weak var placeofBirthLabel: UILabel!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet var collectionOfView: Array<UIView> = []
    
    var idOfPerson: Int?
    private let listingservices = ListingServices()
    private let error = ErrorController.self
    private var person: PersonModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Skeleton.startAnimationArray(outlets: collectionOfView)
        title = person?.name
        if let id = idOfPerson {
            listingservices.getPersonDetail(idOfPerson: id) { result in
                switch result{
                case .success(let newPerson):
                    self.person = newPerson
                   
                    Skeleton.stopAnimationArray(outlets: self.collectionOfView)
                case .failure(let error):
                    print(error)
                }
                self.updateUI()
            }
        } else {
            error.alert(alertInfo: StringKey.noPerson, page: self)
        }
    }
    
    func updateUI() {
        if let imagePosterPath = person?.profile_path {
            personImage.kf.setImage(with: URL(string: Link.poster + (imagePosterPath)))
        } else {
            personImage.image = UIImage(named: "User-avatar.svg")
        }
        if let birthDay = person?.birthday{
            birthday.text = StringKey.birthday + birthDay
        } else {
            birthday.text = StringKey.birthday + StringKey.unDated
        }
        
        if let deathDay = person?.deathday {
            deathday.text = StringKey.deathday + deathDay
        } else {
            deathday.text = StringKey.deathday + StringKey.unDated
        }
        
        if let biograph = person?.biography {
            if biograph.count > 0{
                biography.text = StringKey.bio + biograph
            } else {
                biography.text = StringKey.bio + StringKey.translateError 
            }
            
        } else {
            biography.text = StringKey.emptyContent
        }
        if let pOB = person?.place_of_birth {
            placeofBirthLabel.text = StringKey.placeOfBirth + pOB
        } else {
            placeofBirthLabel.text = StringKey.placeOfBirth + StringKey.unValue
        }
        if let personName = person?.name {
            personalNameLabel.text = personName
        } else {
            personalNameLabel.text = StringKey.unName + StringKey.unValue
        }
    }
}
