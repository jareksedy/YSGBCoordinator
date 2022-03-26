//
//  Coordinator.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 26.03.2022.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }

    init(navigationController:UINavigationController)
    func start()
}
