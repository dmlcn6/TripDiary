//
//  TableCollectionViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/17/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class TableCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var fetchedTrips = [Trip]()
    let reuseIdentifier = "tripcell"
    var selectedTrip: Trip?
    var currUser: User?
    
    let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        layout.sectionInset = UIEdgeInsets(top:1,left:10,bottom:10,right:10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        
        
        collectionView.collectionViewLayout = layout
        
        fetchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData() {
        let fetch = NSFetchRequest<Trip>(entityName: "Trip")
        
        //let predicate = NSPredicate(format: "tripTitle == %@", "*")
        
        //fetch.predicate = predicate
        //fetch.fetchLimit = 2
        
        do{
            fetchedTrips = try DatabaseController.getContext().fetch(fetch)
        }catch let error as NSError {
            print(" hello error \(error.userInfo)")
        }
        
        collectionView.reloadData()
        
    }
    
    //setting num sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    //setting number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchedTrips.isEmpty {
                return 5
        }else{
            return fetchedTrips.count
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTrip = fetchedTrips[indexPath.row]
    }
    
    
    //setting cell properties @ indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tripcell", for: indexPath) as! TripCollectionViewCell
        
        let size = CGSize(width: 125, height: 125)
        
        layout.itemSize = size
        
        cell.backgroundColor = UIColor(red: 0.5, green: 0.2, blue: 0.33, alpha: 0.5)
        
        
        if fetchedTrips.isEmpty{
            print("empty Trip array")
            cell.tripTitle.text = "Ello"
        }else{
            if let tempTitle = fetchedTrips[indexPath.row].tripTitle,
                let cellTripTitle = cell.tripTitle{
                    cellTripTitle.text = tempTitle
                    print(tempTitle)
            }
        }
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMemories"{
            if let dest = segue.destination as? RootTableViewController{
                dest.parentTrip = selectedTrip
                dest.title = selectedTrip?.tripTitle
            }
        }
    }
    

}
