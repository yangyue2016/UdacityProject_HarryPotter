//
//  HouseDetailViewController.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/1/29.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

protocol MemberSelectionDelegate: class {
    func memberSelected(_ selectedMember: Member)
}

class HouseDetailViewController: UIViewController {
    
    weak var delegate: MemberSelectionDelegate?
    
    @IBOutlet weak var founderLabel: UILabel!
    @IBOutlet weak var headOfHouseLabel: UILabel!
    @IBOutlet weak var houseGhostLabel: UILabel!
    @IBOutlet weak var mascotLabel: UILabel!
    @IBOutlet weak var houseNameLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var house: House?
 
    var dataProvider: DataProvider!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Member> = {

        let fetchRequest = NSFetchRequest<Member>(entityName: "Member")
        
        let predicate = NSPredicate(format: "houseID = %@", house!.houseID)
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "memberID", ascending:true)]
        
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
        
        founderLabel?.text = house?.founder
        headOfHouseLabel?.text = house?.headOfHouse
        houseGhostLabel?.text = house?.houseGhost
        mascotLabel?.text = house?.mascot
        houseNameLabel?.text = house?.name
        
        if let houseID = house?.houseID {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                self.dataProvider.fetchMembers(houseID: houseID, completion: { (error) in
                    if error != nil {
                        self.alert(message: error?.localizedDescription ?? "", title: "Error fetching members!")
                        self.activityIndicator.stopAnimating()
                    }
                })
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
           
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CharacterSegue" {
            let vc = segue.destination as! CharacterViewController
            self.delegate = vc
            vc.dataProvider = DataProvider(persistentContainer: CoreDataStack.shared.persistentContainer, api: PotterAPI.shared)
        }
    }
}

extension HouseDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        let member = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = " \(member.memberName) "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMember = fetchedResultsController.object(at: indexPath)
        if delegate != nil {
            delegate?.memberSelected(selectedMember)
        }
    }
}

extension HouseDetailViewController: HouseSelectionDelegate {
    func houseSelected(_ selectedHouse: House) {
        self.house = selectedHouse
    }
}


extension HouseDetailViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
