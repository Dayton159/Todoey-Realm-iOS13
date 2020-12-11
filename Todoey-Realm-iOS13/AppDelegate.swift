//
//  AppDelegate.swift
//  Todoey-Realm
//
//  Created by Dayton on 11/12/20.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // the location of the Realm file
      
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
             _ = try Realm()
        }catch{
            print("Error initialising new realm, \(error)")
        }
        
       
        
        return true
    }
    
    
}
    
   

