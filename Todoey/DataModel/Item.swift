//
//  Item.swift
//  Todoey
//
//  Created by Livia Carvalho Keller on 20/09/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategoy = LinkingObjects(fromType: Category.self, property: "items")
}
