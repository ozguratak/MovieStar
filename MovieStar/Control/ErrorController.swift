//
//  ErrorController.swift
//  MovieStar
//
//  Created by obss on 13.06.2022.
//
//MARK: - Error kontrol sınıfı uygulama genelinde sıklıkla kullanılan pop-up hata mesajlarının singleton olarak toparlanmış bir sınıfıdır. fonksiyon singleton ile çağrıldıktan sonra hata mesajı ve ViewController bilgileri verilerek kullanılabilir. 
import Foundation
import UIKit
class ErrorController {
    
    static func alert(alertInfo: String, page: UIViewController) {
        let alertVC = UIAlertController(title: StringKey.error, message: alertInfo, preferredStyle: .alert)
        let okButton = UIAlertAction(title: StringKey.ok, style: .default) { action in
            page.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(okButton)
        page.present(alertVC, animated: true)
    }
    
    static func alert2Button(alertInfo: String, page: UIViewController, button1: String, button2: String, movieID: Int) {
        let alertVC = UIAlertController(title: StringKey.infoMessage,
                                        message: alertInfo,
                                        preferredStyle: .alert)
       
        let okButton = UIAlertAction(title: button1, style: .default) { action in
            page.navigationController?.popViewController(animated: true)
        }
        let deleteButton = UIAlertAction(title: button2, style: .default) { action2 in
                
            DatabaseManager.init().delete(movieID: movieID)
        
            page.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(okButton)
        alertVC.addAction(deleteButton)
        page.present(alertVC, animated: true)
    }
}

