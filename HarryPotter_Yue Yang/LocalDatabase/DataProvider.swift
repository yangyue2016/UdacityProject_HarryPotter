//
//  DataProvider.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/1/27.
//  Copyright © 2020 Udacity. All rights reserved.
//

import CoreData

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
    case networkUnavailable = 1001
    case wrongDataFormat = 1002
}

class DataProvider {
    
    private let persistentContainer: NSPersistentContainer
    private let api: PotterAPI
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, api: PotterAPI) {
        self.persistentContainer = persistentContainer
        self.api = api
    }
    
    func fetchHouses(completion: @escaping(Error?) -> Void) {
        api.getHouses() { houses, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let houses = houses else {
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncHouses(houses: houses, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    private func syncHouses(houses: [[String: Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingHousesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")
            let houseIDs = houses.map { $0["_id"] as? String }.compactMap { $0 }
            matchingHousesRequest.predicate = NSPredicate(format: "houseID in %@", argumentArray: [houseIDs])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingHousesRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for house in houses {
                
                guard let newHouse = NSEntityDescription.insertNewObject(forEntityName: "House", into: taskContext) as? House else {
                    print("Error: Failed to create a new House object!")
                    return
                }
                
                do {
                    try newHouse.update(with: house)
                } catch {
                    print("Error: \(error)\nThe house object will be deleted.")
                    taskContext.delete(newHouse)
                }
            }
            
            // Save all the changes
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                // Reset the context (free resources)
                taskContext.reset()
            }
            successfull = true
        }
        return successfull
    }
    
    
    func fetchMembers(houseID: String, completion: @escaping(Error?) -> Void) {
        api.getHouse(houseID: houseID) { house, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let house = house else {
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncMembers(house: house, houseID: houseID, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    private func syncMembers(house: NSArray, houseID: String, taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingMemberRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
            let members = house.value(forKey: "members") as! NSArray
            let membersValue = members.firstObject as! NSArray
            let memberIDs = members.value(forKey: "_id") as! NSArray
            let memberIDsValue = memberIDs.firstObject as! [String]
            matchingMemberRequest.predicate = NSPredicate(format: "memberID in %@", argumentArray: [memberIDsValue])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingMemberRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for member in membersValue {

                guard let newMember = NSEntityDescription.insertNewObject(forEntityName: "Member", into: taskContext) as? Member else {
                    print("Error: Failed to create a new Member object!")
                    return
                }
                
                do {
                    try newMember.update(with: member as! [String: Any], houseID: houseID)
                } catch {
                    print("Error: \(error)\nThe house object will be deleted.")
                    taskContext.delete(newMember)
                }
 
            }
            
            // Save all the changes
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                // Reset the context (free resources)
                taskContext.reset()
            }
            successfull = true
        }
        return successfull
    }
 
    func fetchCharacter(characterID: String, completion: @escaping(Error?) -> Void) {
        api.getCharacter(characterID: characterID) { character, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let character = character else {
                completion(error)
                return
            }
            
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncCharacter(character: character, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    private func syncCharacter(character: [String:Any], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingCharacterRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
            let characterID = character["_id"] as! String
            //matchingCharacterRequest.predicate = NSPredicate(format: "characterID in %@", argumentArray: [characterID])
            matchingCharacterRequest.predicate = NSPredicate(format: "characterID LIKE[c] %@", argumentArray: [characterID])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingCharacterRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                 if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            
            
            // Create new records.
            guard let newCharacter = NSEntityDescription.insertNewObject(forEntityName: "Character", into: taskContext) as? Character else {
                print("Error: Failed to create a new Character object!")
                return
            }
                
            do {
                try newCharacter.update(with: character as! [String: Any])
            } catch {
                print("Error: \(error)\nThe character object will be deleted.")
                taskContext.delete(newCharacter)
            }
 
    
            
            // Save all the changes
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                // Reset the context (free resources)
                taskContext.reset()
            }
            successfull = true
        }
        return successfull
    }
}

