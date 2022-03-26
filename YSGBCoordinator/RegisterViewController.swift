//
//  RegisterViewController.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 26.03.2022.
//

import UIKit
import RealmSwift

public protocol RegisterViewControllerDelegate: AnyObject {
    func navigateToLogin()
}

class RegisterViewController: UIViewController {
    // MARK: -- Outlets.
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    public weak var delegate: RegisterViewControllerDelegate?
    let realm: Realm = try! Realm()
    
    private func writeToDB(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: -- Selectors.
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        contentInset.bottom = keyboardFrame.size.height + 50
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: -- Actions.
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
              let login = loginTextField.text,
              let password = passwordTextField.text,
              let passAgain = passwordAgainTextField.text
        else { return }
        
        guard name != "", login != "", password != "", passAgain != "" else { return }
        
        guard password == passAgain else { return }
        
        let user = User()
        
        user.name = name
        user.login = login
        user.password = password
        
        writeToDB(user: user)
        
        self.delegate?.navigateToLogin()
        
    }
    
    // MARK: -- Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        registerNotifications()
    }
}

