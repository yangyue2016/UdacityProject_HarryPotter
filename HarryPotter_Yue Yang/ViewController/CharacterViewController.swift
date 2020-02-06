//
//  CharacterViewController.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/2/2.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

class CharacterViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var bloodStatusLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var wandLabel: UILabel!
    @IBOutlet weak var boggartLabel: UILabel!
    @IBOutlet weak var animagusLabel: UILabel!
    @IBOutlet weak var deathEaterLabel: UILabel!
    @IBOutlet weak var dumbledoresArmyLabel: UILabel!
    @IBOutlet weak var orderOfThePhoenixLabel: UILabel!
    @IBOutlet weak var ministryOfMagicLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var member: Member?
    
    var dataProvider: DataProvider!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Character> = {
        let fetchRequest = NSFetchRequest<Character>(entityName: "Character")
        
        let predicate = NSPredicate(format: "characterID = %@", member!.memberID)
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "characterID", ascending:true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nsError = error as NSError
            fatalError("Fatal error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = member?.memberName
        
        if let characterID = member?.memberID {
            
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                self.dataProvider.fetchCharacter(characterID: characterID,  completion: { (error) in
                    if error != nil {
                        self.alert(message: error?.localizedDescription ?? "", title: "Error fetching character!")
                        self.activityIndicator.stopAnimating()
                    }
                })
            
                if self.fetchedResultsController.fetchedObjects!.isEmpty == false {
 //                   self.alert(message: "The information of this character is not available!")
//                    self.activityIndicator.stopAnimating()
//                } else {
                
                    let character = self.fetchedResultsController.fetchedObjects![0]
                    
                    self.houseLabel.text = character.house
                    self.speciesLabel.text = character.species
                    self.bloodStatusLabel.text = character.bloodStatus
                    self.roleLabel.text = character.role
                    self.aliasLabel.text = character.alias
                    self.wandLabel.text = character.wand
                    self.boggartLabel.text = character.boggart
                    self.animagusLabel.text = character.animagus
                    if character.deathEater {
                        self.deathEaterLabel.text = "Yes"
                    } else {
                        self.deathEaterLabel.text = "No"
                    }
                    
                    if character.dumbledoresArmy {
                        self.dumbledoresArmyLabel.text = "Yes"
                    } else {
                        self.dumbledoresArmyLabel.text = "No"
                    }
                    
                    if character.orderOfThePhoenix {
                        self.orderOfThePhoenixLabel.text = "Yes"
                    } else {
                        self.orderOfThePhoenixLabel.text = "No"
                    }
                    
                    if character.ministryOfMagic {
                        self.ministryOfMagicLabel.text = "Yes"
                    } else {
                        self.ministryOfMagicLabel.text = "No"
                    }
                    
                }
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }

        }
    }
}

extension CharacterViewController: MemberSelectionDelegate {
    func memberSelected(_ selectedMember: Member) {
        self.member = selectedMember
    }
}
