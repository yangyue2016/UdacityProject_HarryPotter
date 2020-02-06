//
//  Character.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/1/30.
//  Copyright © 2020 Udacity. All rights reserved.
//

import CoreData

class Character: NSManagedObject {
    
    @NSManaged var characterID: String
    @NSManaged var name: String
    @NSManaged var house: String
    @NSManaged var patronus: String
    @NSManaged var species: String
    @NSManaged var bloodStatus: String
    @NSManaged var role: String
    @NSManaged var school: String
    @NSManaged var deathEater: Bool
    @NSManaged var dumbledoresArmy: Bool
    @NSManaged var orderOfThePhoenix: Bool
    @NSManaged var ministryOfMagic: Bool
    @NSManaged var alias: String
    @NSManaged var wand: String
    @NSManaged var boggart: String
    @NSManaged var animagus: String
    
    func update(with character: [String: Any]) throws {
        
        guard let characterID = character["_id"] as? String,
            let name = character["name"] as? String
            else {
                throw NSError(domain: "", code: 1000, userInfo: nil)
        }
        
        self.characterID = characterID
        self.name = name
        self.house = character["house"] as? String ?? "unknown"
        self.patronus = character["patronus"] as? String ?? "unknown"
        self.species = character["species"] as? String ?? "unknown"
        self.bloodStatus = character["bloodStatus"] as? String ?? "unknown"
        self.role = character["role"] as? String ?? "unknown"
        self.school = character["school"] as? String ?? "unknown"
        self.deathEater = character["deathEater"] as? Bool ?? false
        self.dumbledoresArmy = character["dumbledoresArmy"] as? Bool ?? false
        self.orderOfThePhoenix = character["orderOfThePhoenix"] as? Bool ?? false
        self.ministryOfMagic = character["ministryOfMagic"] as? Bool ?? false
        self.alias = character["alias"] as? String ?? "unknown"
        self.wand = character["wand"] as? String ?? "unknown"
        self.boggart = character["boggart"] as? String ?? "unknown"
        self.animagus = character["animagus"] as? String ?? "unknown"
        
    }
}

