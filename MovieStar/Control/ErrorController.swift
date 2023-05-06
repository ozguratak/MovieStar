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
    
    static func deleteAccount(page: UIViewController) {
        let alertVC = UIAlertController(title: "Are you sure?", message: "We are so sorry about this leaving... Are you sure want to delete your account?", preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "I'm Sure", style: .default) { action in
            User().deleteUser()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
            page.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        let dismissButton = UIAlertAction(title: "Dismiss!", style: .default) { action in
            alertVC.dismiss(animated: true)
        }
        
        alertVC.addAction(confirmButton)
        alertVC.addAction(dismissButton)
        page.present(alertVC, animated: true)
        
        
    }
    
    static func message(page: UIViewController, message: String, title: String, action: Bool, completion: @escaping (_ action: UIAlertController) -> Void) {
        
        let notificationVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        page.present(notificationVC, animated: true)
        if action {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                notificationVC.dismiss(animated: true)
            }
        }
        completion(notificationVC)
    }
    
    
}

