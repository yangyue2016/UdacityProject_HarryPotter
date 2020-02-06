//
//  ViewController.swift
//  HarryPorter_Yue Yang
//
//  Created by MacAir11 on 2020/1/22.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

protocol HouseSelectionDelegate: class {
    func houseSelected(_ selectedHouse: House)
}

class CollectionViewController: UIViewController,  NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            self.dataProvider.fetchHouses { (error) in
                
                if error != nil {
                    self.alert(message: error?.localizedDescription ?? "", title: "Error fetching houses!")
                    self.activityIndicator.stopAnimating()
                }
            }
            
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "houseDetailSegue" {
            let viewController = segue.destination as! HouseDetailViewController
            self.delegate = viewController
            viewController.dataProvider = DataProvider(persistentContainer: CoreDataStack.shared.persistentContainer, api: PotterAPI.shared)
        }
    }

}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        let house = fetchedResultsController.object(at: indexPath)
        // Set the name and image
        let image:UIImage = UIImage(named: house.name)!
        cell.collectionCellImage?.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedHouse = fetchedResultsController.object(at: indexPath)
        if delegate != nil {
            delegate?.houseSelected(selectedHouse)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 150.0, height: 150.0)
    }
}
