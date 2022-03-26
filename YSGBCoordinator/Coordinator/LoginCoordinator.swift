//
//  LoginCoordinator.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 26.03.2022.
//

import UIKit

class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        loginViewController.delegate = self
        self.navigationController.viewControllers = [loginViewController]
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func navigateToSuccess() {
        let successViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessVC") as! SuccessViewController
        self.navigationController.viewControllers = [successViewController]
    }
    
    func navigateToRegister() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.delegate = self
        childCoordinators.append(registerCoordinator)
        registerCoordinator.start()
    }
}

extension LoginCoordinator: BackToLoginViewControllerDelegate {
    func navigateBackToLogin(newCoordinator: RegisterCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
