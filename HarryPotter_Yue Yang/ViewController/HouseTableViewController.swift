//
//  HouseTableViewController.swift
//  HarryPotter_Yue Yang
//
//  Created by MacAir11 on 2020/1/28.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

protocol HouseSelectionDelegate: class {
    func houseSelected(_ selectedHouse: House)
}

class HouseTableViewController: UITableViewController {
    
    weak var delegate: HouseSelectionDelegate?
    
    var dataProvider: DataProvider!
    
    lazy var fetchedResultsController: NSFetchedResultsController<House> = {
        let fetchRequest = NSFetchRequest<House>(entityName: "House")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "houseID", ascending:true)]
        
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

        self.title = "Hogwarts Houses"
        
        dataProvider.fetchHouses { (error) in
            
            if error != nil {
                print("Error fetching houses!")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath)
        let house = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = " \(house.name) "
        cell.detailTextLabel?.text = house.founder
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHouse = fetchedResultsController.object(at: indexPath)
        if delegate != nil {
            delegate?.houseSelected(selectedHouse)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "houseDetailSegue" {
            let vc = segue.destination as! HouseDetailViewController
            self.delegate = vc
            vc.dataProvider = DataProvider(persistentContainer: CoreDataStack.shared.persistentContainer, api: PotterAPI.shared)
        }
    }
    
}

extension HouseTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
