//
//  LoginViewController.swift
//  MovieStar
//
//  Created by ozgur.atak on 11.04.2023.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButtonOutlet: UIButton!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func eyeButtonAction(_ sender: Any) {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            eyeButtonOutlet.setImage(UIImage.init(systemName: "eye.slash"), for: .normal)
            eyeButtonOutlet.tintColor = .black
            
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeButtonOutlet.setImage(UIImage.init(systemName: "eye"), for: .normal)
            eyeButtonOutlet.tintColor = .black
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        autoLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        loadingActivityIndicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 200
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func autoLogin(){
        if let state = UserDefaults.standard.value(forKey: "remindMeSwitch"), let pass = UserDefaults.standard.value(forKey: "password"), let mail = UserDefaults.standard.value(forKey: "email") {
            passwordTextField.text = pass as? String
            mailTextField.text = mail as? String
            DispatchQueue.main.async {
                self.loginActions()
            }
        }
    }
    
    private func loginActions() {
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
        if mailTextField.text != nil && passwordTextField.text != nil {
            
            FirebaseAuthenticationManager().loginUser(email: self.mailTextField.text!, password: self.passwordTextField.text!) { error, authData, ID  in
                if error == nil {
                    
                    if authData == true {
                        UserDefaults.standard.set(self.mailTextField.text, forKey: "email")
                        UserDefaults.standard.set(self.passwordTextField.text, forKey: "password")
                        self.accessLogin()
                        currentEmail = self.mailTextField.text!
                        self.fetchUserData()
                        self.loadingActivityIndicator.isHidden = true
                        self.loadingActivityIndicator.stopAnimating()
                        ErrorController.message(page: self, message: "Verified access. Welcome!", title: "Good News!", action: true) { action in
                            action.dismiss(animated: true)
                        }
                        
                    } else {
                        ErrorController.message(page: self, message: "Your e-mail was not verified. Please check your e-mail.", title: "Oops!", action: true) { action in
                            action.dismiss(animated: true)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.accessLogin()
                            self.fetchUserData()
                            self.loadingActivityIndicator.isHidden = true
                            self.loadingActivityIndicator.stopAnimating()
                        }
                    }
                    
                } else {
                    ErrorController.alert(alertInfo: String(describing: error!), page: self)
                    self.loadingActivityIndicator.isHidden = true
                    self.loadingActivityIndicator.stopAnimating()
                }
            }
        } else {
            ErrorController.alert(alertInfo: "Please fill all the blanks!", page: self)
            self.loadingActivityIndicator.isHidden = true
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    
    private func fetchUserData() {
        User().downloadFileFromFirebaseStorage(id: userID!) { result in
            switch result {
            case .success(let user):
                currentUserInformation = user
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func accessLogin() {
        let mainSb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let appVC = mainSb.instantiateViewController(identifier: "MovieListViewController")
        navigationController?.navigationItem.setHidesBackButton(true, animated: true)
        show(appVC, sender: self)
    }
    
}
