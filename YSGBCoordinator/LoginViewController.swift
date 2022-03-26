//
//  ViewController.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 24.03.2022.
//

import UIKit
import RealmSwift

public protocol LoginViewControllerDelegate: AnyObject {
    func navigateToRegister()
    func navigateToSuccess()
}

class LoginViewController: UIViewController {
    // MARK: -- Outlets.
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    public weak var delegate: LoginViewControllerDelegate?
    let realm: Realm = try! Realm()
    
    private func authenticated(login: String, password: String) -> Bool {
        let user = realm.object(ofType: User.self, forPrimaryKey: login)
        guard let user = user else {
            return false
        }
        
        if user.password == password { return true } else { return false }
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
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        guard login != "", password != "" else { return }
        
        print(login, password, authenticated(login: login, password: password))
        
        if authenticated(login: login, password: password) {
            self.delegate?.navigateToSuccess()
        } else {
            self.delegate?.navigateToRegister()
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        self.delegate?.navigateToRegister()
    }
    
    // MARK: -- Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        setupGestures()
        registerNotifications()
    }
}

