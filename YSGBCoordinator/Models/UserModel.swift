//
//  UserModel.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 24.03.2022.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var login: String
    @Persisted var password: String
    @Persisted var name: String
}
