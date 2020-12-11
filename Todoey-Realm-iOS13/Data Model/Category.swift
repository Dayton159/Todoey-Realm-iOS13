//
//  Category.swift
//  Todoey-Realm
//
//  Created by Dayton on 11/12/20.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var color:String = ""
    //defining one to many relationship
    //each category has one to many relationship
    let items = List<Item>()
}
