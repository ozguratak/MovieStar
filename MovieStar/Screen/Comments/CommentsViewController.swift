//
//  CommentsViewController.swift
//  MovieStar
//
//  Created by ozgur.atak on 12.04.2023.
//

import UIKit

@available(iOS 15, *)
class CommentsViewController: UIViewController {
    
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var commentsCounter: UILabel!
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            commentsTableView.dataSource = self
            commentsTableView.delegate = self
            commentsTableView.register(UINib(nibName: String(describing: CommentCells.self), bundle: nil),
                                       forCellReuseIdentifier: String(describing: CommentCells.self))
            commentsTableView.allowsSelection = false
        }
    }
    
    var idOfMovie: Int?
    let manager = FirebaseCommentManager()
    var comments: [CommentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCommentTextField.delegate = self
        getCommentsOfMovie()
        commentsCounter.text = String(describing: comments.count)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        let rightBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(saveButtonTapped))
        rightBarButton.image = UIImage(systemName: "figure.wave.circle")
        navigationItem.rightBarButtonItem = rightBarButton
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
    
    @objc func saveButtonTapped() {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ProfileSettingViewController.self)) as? ProfileSettingViewController{
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    private func getCommentsOfMovie() { //listing of comment from Firebase
        manager.downloadCommentsFromFirestore { commentArray in
            if !commentArray.isEmpty {
                for comment in commentArray{
                    if comment.movieID == self.idOfMovie! {
                        self.comments.append(comment)
                        self.commentsCounter.text = "\(String(describing: self.comments.count)) Comments"
                    }
                }
                self.commentsTableView.reloadData()
                self.dismissKeyboard()
            } else {
                self.commentsCounter.text = "Not found any comment"
            }
        }
    }
    
    func dateFormatter() -> String {
        let timestamp = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

@available(iOS 15, *)
extension CommentsViewController: UITableViewDelegate, UITableViewDataSource { //Table view controls
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCells.self), for: indexPath) as! CommentCells
        cell.configure(comment: comments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if comments[indexPath.row].userID == currentUserInformation?.objectID {
                printContent("deletable")
            }
            tableView.reloadData()
        }
    }
}

@available(iOS 15, *)
extension CommentsViewController: UITextFieldDelegate { //Comment adding controls
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //comment send to Firebase
        guard let text = textField.text else { return true }
        manager.createCommentSet(date: dateFormatter(), movieID: idOfMovie!, commentID: String(describing: UUID().uuidString), comment: text, name: currentUserInformation?.name ?? "Unknown", lastName: currentUserInformation?.lastName ?? "User")
        ErrorController.message(page: self, message: "Comment added!", title: "Good!", action: true) { action in
            DispatchQueue.global(qos: .userInteractive).async {
                self.comments.removeAll()
                self.getCommentsOfMovie()
            }
            self.dismissKeyboard()
        }
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
