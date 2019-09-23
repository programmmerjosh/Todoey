//
//  AppDelegate.swift
//  Todoey
//
//  Created by admin on 16/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // how to locate your Realm File:
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // just to catch any errors when initializing Realm
        do {
            _ = try Realm()
        } catch {
            print("Error with Realm: \(error)")
        }
        return true
    }
}

