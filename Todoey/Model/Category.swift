//
//  Category.swift
//  Todoey
//
//  Created by admin on 21/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    // the 'dynamic' key word monitors changes in the property while the app s running
    @objc dynamic var name    : String = ""
    @objc dynamic var hexColor: String = ""
    // List<> is Realm syntax for creating a list of Item objects
                  let items            = List<Item>()
}
