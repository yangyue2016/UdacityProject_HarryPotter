//
//  CoreDataStack.swift
//  HarryPorter_Yue Yang
//
//  Created by MacAir11 on 2020/1/27.
//  Copyright © 2020 Udacity. All rights reserved.
//

import CoreData

// Singleton classs that exposes NSPersistentContainer
class CoreDataStack {
    
    private init() {}
    
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HarryPotterDB")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Fatal error: \(error), \(error.userInfo)")
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
}

