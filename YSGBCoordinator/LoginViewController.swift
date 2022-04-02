//
//  ViewController.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 24.03.2022.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

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
    let disposeBag = DisposeBag()
    
    private func authenticated(login: String, password: String) -> Bool {
        let user = realm.object(ofType: User.self, forPrimaryKey: login)
        guard let user = user else {
            return false
        }
        
        if user.password == password { return true } else { return false }
    }
    
    private func setupUI() {
        loginTextField.autocorrectionType = .no
    }
    
    private func setupRx() {
        let isLoginValid = loginTextField.rx.text.orEmpty
            .map { $0.count >= 1 }
            .share(replay: 1)
        
        let isPasswordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 1 }
            .share(replay: 1)
        
        let isEverythingValid = Observable.combineLatest(isLoginValid, isPasswordValid) { (login, password) in
            return login && password
        }
        
        isEverythingValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isEverythingValid
            .map { $0 ? 1.0 : 0.25 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
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
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        setupUI()
        setupRx()
        
        setupGestures()
        registerNotifications()
    }
}

