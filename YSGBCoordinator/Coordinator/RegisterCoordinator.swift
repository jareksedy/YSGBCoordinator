//
//  RegisterCoordinator.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 26.03.2022.
//

import UIKit

protocol BackToLoginViewControllerDelegate: AnyObject {
    func navigateBackToLogin(newCoordinator: RegisterCoordinator)
}

class RegisterCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    unowned let navigationController: UINavigationController
    weak var delegate: BackToLoginViewControllerDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let registerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterViewController
        registerViewController.delegate = self
        self.navigationController.viewControllers = [registerViewController]
    }
}

extension RegisterCoordinator: RegisterViewControllerDelegate {
    
    func navigateToLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        //loginCoordinator.delegate = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
}
