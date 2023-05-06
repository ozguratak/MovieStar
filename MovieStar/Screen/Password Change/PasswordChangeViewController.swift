//
//  PasswordChangeViewController.swift
//  MovieStar
//
//  Created by ozgur.atak on 18.04.2023.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    @IBOutlet weak var passwordPowerBar: UIProgressView! {
        didSet {
            passwordPowerBar.progress = 0
        }
    }
    @IBOutlet weak var newPassConfirmTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var passwordPoint: UILabel!
    @IBOutlet weak var changeButtonOutlet: UIButton! {
        didSet {
            changeButtonOutlet.isEnabled = false
        }
    }
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        if compareTextFields() {
            if let pass = newPassConfirmTextField.text {
                    User().changePassword(newPassword: pass, page: self)
            }
        } else {
            ErrorController.alert(alertInfo: "Password's are not equal!", page: self)
        }
    }
    var progressScore: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPassTextField.delegate = self
        newPassConfirmTextField.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
   private func compareTextFields() -> Bool {
       if let newpass = newPassTextField.text, let newPassConf = newPassConfirmTextField.text {
           if newpass == newPassConf {
               return true
           } else {
               if newPassConf.count >= 8 {
                   ErrorController.alert(alertInfo: "Your passwords are not equal", page: self)
               }
           }
           return false
       }
       ErrorController.alert(alertInfo: "Please check your passwords, They are not looks like a password.", page: self)
       return false
    }

    func validatePassword(password: String) -> Bool {
        
        if password.rangeOfCharacter(from: .lowercaseLetters) == nil {
            ErrorController.alert(alertInfo: "Your password should be ingrediate minimum one lowercased character.", page: self)
            return false
        }
        
        if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            ErrorController.alert(alertInfo: "Your password should be ingrediate minimum one uppercased character.", page: self)
            return false
        }
        
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            ErrorController.alert(alertInfo: "Your password should be ingrediate minimum one any number character.", page: self)
            return false
        }
        return true
    }

   private func updateProgress() {
            let completedParts = progressScore / 0.25
            passwordPowerBar.progress = completedParts * 0.25
        }

   private func checkPasswordStrength(password: String) {
       
       progressScore = 0.0
       passwordPowerBar.progress = progressScore
       
       if password.count > 2 && password.count < 8 {
           ErrorController.alert(alertInfo: "Your password will be minimum 8 character length", page: self)
            progressScore += 0.0
            updateProgress()
            passwordPoint.text = "0/4"
        }
       
        let pattern = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: password.utf16.count)
        if regex.firstMatch(in: password, options: [], range: range) != nil {
            progressScore += 0.1
            updateProgress()
            passwordPoint.text = "1/4"
            
        }
        
        if password.range(of: #"[^a-zA-Z0-9]"#, options: .regularExpression) != nil {
            progressScore += 0.1
            updateProgress()
            passwordPoint.text = "2/4"
        }
        
        if password.range(of: #"[üÜçÇğĞıİöÖşŞ]"#, options: .regularExpression) != nil && password.range(of: #"[^a-zA-Z0-9çÇğĞıİöÖşŞ]"#, options: .regularExpression) != nil {
            progressScore += 0.1
            updateProgress()
            passwordPoint.text = "3/4"
        }
        
        if progressScore == 3 && password.range(of: #"[^a-zA-Z0-9çÇğĞıİöÖşŞ]"#, options: .regularExpression) != nil {
            progressScore += 0.1
            updateProgress()
            passwordPoint.text = "4/4"
        }
    }
}

extension PasswordChangeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let pass = newPassTextField.text {
            checkPasswordStrength(password: pass)
            
            if validatePassword(password: pass) {
                if compareTextFields() {
                    changeButtonOutlet.isEnabled = true
                } else {
                    changeButtonOutlet.isEnabled = false
                }
                
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        passwordPowerBar.progress = 0.0
        passwordPoint.text = "0/4"
    }
}
