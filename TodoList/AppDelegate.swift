//
//  AppDelegate.swift
//  TodoList
//
//  Created by Hasan Aden on 13/06/2019.
//  Copyright © 2019 hasan. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        }catch {
            print("Error installing RealmSwift \(error)")
        }
        
        return true
    }


   
}


