//
//  RegisterViewController.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 26.03.2022.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

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
    let disposeBag = DisposeBag()
    
    private func writeToDB(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    private func setupUI() {
        loginTextField.autocorrectionType = .no
        nameTextField.autocorrectionType = .no
    }
    
    private func setupRx() {
        let isLoginValid = loginTextField.rx.text.orEmpty
            .map { $0.count >= 1 }
            .share(replay: 1)
        
        let isPasswordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 1 }
            .share(replay: 1)
        
        let isPasswordAgainValid = passwordAgainTextField.rx.text.orEmpty
            .map { $0.count >= 1 }
            .share(replay: 1)
        
        let isNameValid = nameTextField.rx.text.orEmpty
            .map { $0.count >= 1 }
            .share(replay: 1)
        
        let doPasswordsMatch = Observable.combineLatest(passwordTextField.rx.text, passwordAgainTextField.rx.text) { (password, passwordAgain) in
            return password == passwordAgain
        }
        
        let isEverythingValid = Observable.combineLatest(isLoginValid, isPasswordValid, isPasswordAgainValid, isNameValid, doPasswordsMatch) { (login, password, passwordAgain, name, passwordsMatch) in
            return login && password && passwordAgain && name && passwordsMatch
        }
        
        isEverythingValid
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isEverythingValid
            .map { $0 ? 1.0 : 0.25 }
            .bind(to: registerButton.rx.alpha)
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
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
              let login = loginTextField.text,
              let password = passwordTextField.text
        else { return }
        
//        guard name != "", login != "", password != "", passAgain != "" else { return }
//        guard password == passAgain else { return }
        
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
        
        setupUI()
        setupRx()
        
        setupGestures()
        registerNotifications()
    }
}

