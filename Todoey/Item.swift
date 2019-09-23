//
//  Item.swift
//  Todoey
//
//  Created by admin on 21/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name       : String = ""
    @objc dynamic var checked    : Bool   = false
    @objc dynamic var dateCreated: Date?
    // specifying the inverse relationship that links each item back to a parent category 
                  var parentCategory      = LinkingObjects(fromType: Category.self, property: "items")
}
