//
//  ProfileSettingViewController.swift
//  MovieStar
//
//  Created by ozgur.atak on 17.04.2023.
//

import UIKit
import MessageUI

class ProfileSettingViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!{
        didSet{
            nameTF.placeholder = currentUserInformation?.name
        }
    }
    @IBOutlet weak var lastNameTF: UITextField! {
        didSet{
            lastNameTF.placeholder = currentUserInformation?.lastName
        }
    }
    @IBOutlet weak var emailTF: UITextField!{
        didSet{
            emailTF.placeholder = currentUserInformation?.mail
        }
    }
    
    @IBAction func changePassButtonPressed(_ sender: UIButton) {
        if let passwordChangeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: PasswordChangeViewController.self)) as? PasswordChangeViewController {
            let dismissButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissWebpage))
            passwordChangeVC.navigationItem.rightBarButtonItem = dismissButton
            
            let navController = UINavigationController(rootViewController: passwordChangeVC)
            navController.modalPresentationStyle = .pageSheet
            self.present(navController, animated: true)
        }
    }
    
    @IBAction func updateInfoPressed(_ sender: Any) {
        
    }
    
    @IBAction func remindMeSwitch(_ sender: UISwitch) {
        if sender.isOn {
              UserDefaults.standard.set(true, forKey: "remindMeSwitch")
          } else {
              UserDefaults.standard.set(false, forKey: "remindMeSwitch")
              UserDefaults.standard.removeObject(forKey: "email")
              UserDefaults.standard.removeObject(forKey: "password")
          }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        FirebaseAuthenticationManager().logOutUser(page: self)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        ErrorController.deleteAccount(page: self)
    }
    
    @IBAction func privacyButtonPressed(_ sender: UIButton) {
        if let webpageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: WebpageViewerViewController.self)) as? WebpageViewerViewController{
            webpageVC.link = URL(string: "https://github.com/ozguratak/Documents/blob/main/Privacy%20Policy.pdf")
            let dismissButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissWebpage))
            webpageVC.navigationItem.rightBarButtonItem = dismissButton
            
            let navController = UINavigationController(rootViewController: webpageVC)
            navController.modalPresentationStyle = .pageSheet
            self.present(navController, animated: true)
        }
    }
    
    @objc private func dismissWebpage() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func legacyButtonPressed(_ sender: UIButton) {
        if let webpageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: WebpageViewerViewController.self)) as? WebpageViewerViewController{
            webpageVC.link = URL(string: "https://github.com/ozguratak/Documents/blob/main/Licance%20.pdf")
            let dismissButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissWebpage))
            webpageVC.navigationItem.rightBarButtonItem = dismissButton
            
            let navController = UINavigationController(rootViewController: webpageVC)
            navController.modalPresentationStyle = .pageSheet
            self.present(navController, animated: true)
        }
    }
    
    @IBAction func resendConfirmationMailPressed(_ sender: Any) {
        User().resendVerifyMail()
        ErrorController.message(page: self, message: "We send a new confirmation e-mail to your \(String(describing: currentUserInformation?.mail)) address.", title: "Complete!", action: true) { action in
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func contacUsButtonPressed(_ sender: UIButton) {
        sendMail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile Settings"
        hideKeyboardWhenTappedAround()
    }
    
}

extension ProfileSettingViewController: MFMailComposeViewControllerDelegate {
    func sendMail(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["email@example.com"]) // alıcı adresi
            mail.setSubject("Film Listem Uygulaması Hk.") // mail konusu
            mail.setMessageBody("<p> Merhaba! <p> <p> Ben \(String(describing: currentUserInformation?.name)), <p> <p>Uygulamanızz hakkında size bir kaç şey iletmem gerekiyor. İşte size aktarmak istediklerim; </p>", isHTML: true) // mail içeriği
            
            present(mail, animated: true)
        } else {
            ErrorController.alert(alertInfo: "Your device has not support for sending a mail.", page: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
