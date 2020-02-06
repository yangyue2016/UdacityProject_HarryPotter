//
//  House.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/1/27.
//  Copyright © 2020 Udacity. All rights reserved.
//

import CoreData

class House: NSManagedObject {
    
    @NSManaged var founder: String
    @NSManaged var headOfHouse: String
    @NSManaged var houseGhost: String
    @NSManaged var houseID: String
    @NSManaged var mascot: String
    @NSManaged var name: String
    @NSManaged var school: String
    @NSManaged var members: [String]
    
    
    func update(with house: [String: Any]) throws {
        
        guard let founder = house["founder"] as? String,
            let headOfHouse = house["headOfHouse"] as? String,
            let houseGhost = house["houseGhost"] as? String,
            let houseID = house["_id"] as? String,
            let mascot = house["mascot"] as? String,
            let name = house["name"] as? String
            else {
                throw NSError(domain: "", code: 1000, userInfo: nil)
        }
        
        self.founder = founder
        self.headOfHouse = headOfHouse
        self.houseGhost = houseGhost
        self.houseID = houseID
        self.mascot = mascot
        self.name = name
        self.school = house["school"] as? String ?? "Hogwarts School of Witchcraft and Wizardry"

    }
}
