//
//  RegisterViewController.swift
//  MovieStar
//
//  Created by ozgur.atak on 11.04.2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker! {
        didSet{
            birthdayPicker.datePickerMode = .date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let minimumDate = dateFormatter.date(from: "01.01.1970")
            birthdayPicker.minimumDate = minimumDate
            birthdayPicker.maximumDate = Date()
        }
    }
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        fieldCheck()
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        loadingActivityIndicator.isHidden = true
        
        hideKeyboardWhenTappedAround()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func fieldCheck() {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            FirebaseAuthenticationManager().registerUser(email: email, password: password, name: nameTextField.text ?? "User Name", lastName: lastNameTextField.text ?? "User Last Name", birthDay: birthdayPicker.date) { error in
                if error == nil {
                    self.loadingActivityIndicator.stopAnimating()
                    self.loadingActivityIndicator.isHidden = true
                    self.dismiss(animated: true)
                    
                } else {
                    ErrorController.alert(alertInfo: "Your account can not be create now: \(String(describing: error?.localizedDescription)) ", page: self)
                    self.loadingActivityIndicator.stopAnimating()
                    self.loadingActivityIndicator.isHidden = true
                }
            }
        }
    }
    
    
    
}
