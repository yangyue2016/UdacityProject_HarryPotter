//
//  Member.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/2/1.
//  Copyright © 2020 Udacity. All rights reserved.
//

import CoreData

class Member: NSManagedObject {
    
    @NSManaged var houseID: String
    @NSManaged var memberID: String
    @NSManaged var memberName: String
    
    func update(with member: [String: Any], houseID: String) throws {
        
        guard let houseID = houseID as? String,
            let memberID = member["_id"] as? String,
            let memberName = member["name"] as? String
            else {
                throw NSError(domain: "", code: 1000, userInfo: nil)
        }
        
        self.houseID = houseID
        self.memberID = memberID
        self.memberName = memberName
        
    }
}
