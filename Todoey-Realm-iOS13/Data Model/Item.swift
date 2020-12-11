//
//  Item.swift
//  Todoey-Realm
//
//  Created by Dayton on 11/12/20.
//

import Foundation
import RealmSwift

class Item: Object {
    //dynamic var allows realm to monitor for changes in property while the app is running
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date? //this is the new date
   
    
    //inverse relationship defined here
    //each item has inverse relationship to a category or a parentCategory
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

