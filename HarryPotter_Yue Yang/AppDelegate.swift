//
//  AppDelegate.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/1/27.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var coreDataStack = CoreDataStack.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = window?.rootViewController as? UINavigationController
        //let tableViewController = rootViewController?.topViewController as? HouseTableViewController
        
        //tableViewController?.dataProvider = DataProvider(persistentContainer: coreDataStack.persistentContainer, api: PotterAPI.shared)
        
        let collectionViewController = rootViewController?.topViewController as? CollectionViewController
        
        collectionViewController?.dataProvider = DataProvider(persistentContainer: coreDataStack.persistentContainer, api: PotterAPI.shared)
        
        return true
    }
}
