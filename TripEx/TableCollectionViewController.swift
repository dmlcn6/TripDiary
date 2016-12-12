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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var fetchedTrips = [Trip]()
    let reuseIdentifier = "tripcell"
    var selectedTrip: Trip?
    var selectedIndexPath: IndexPath = IndexPath()
    var currUser: User?
    
    
    let layout = UICollectionViewFlowLayout()
    var cellCount = 1
    let searchTitle = "tripTitle"
    let searchDate = "tripDate"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Changes Top Bar Color
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0)
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        layout.sectionInset = UIEdgeInsets(top:1,left:10,bottom:10,right:10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        
        
        collectionView.collectionViewLayout = layout
        
        fetchData(searchDate)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        fetchData(searchDate)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchTrips(_ sender: Any) {
        

    }
    
    
    @IBAction func segmentChange(_ sender: Any) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            fetchData(searchTitle)
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            fetchData(searchDate)
        }
    }
    
    func fetchData(_ key: String) {
        let fetch = NSFetchRequest<Trip>(entityName: "Trip")
        
        //let predicate = NSPredicate(format: "tripTitle == %@", "*")
        
        //fetch.predicate = predicate
        //fetch.fetchLimit = 2
        let descript = NSSortDescriptor(key: key, ascending: true)
        fetch.sortDescriptors = [descript]
        
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
            cellCount = 0
            return 1
        }else{
            return fetchedTrips.count
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTrip = fetchedTrips[indexPath.row]
        selectedIndexPath = indexPath
        
    }
    
    
    //setting cell properties @ indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tripcell", for: indexPath) as! TripCollectionViewCell
        
        
        let size = CGSize(width: 200, height: 200)
        layout.itemSize = size
        cell.backgroundColor = UIColor(red: 0.5, green: 0.2, blue: 0.33, alpha: 0.5)
        
        if cellCount == 0 {
            if let cellTripTitle = cell.tripTitle {
                cellTripTitle.text = "NO TRIPS"
                // set the image to be a big plus sign
            }
        }else {
            if let cellTripTitle = cell.tripTitle, let cellTripImageView = cell.coverPhotoImageView{
                
                cellTripTitle.text = fetchedTrips[indexPath.row].tripTitle
                if let tripPhoto: MemoryPhoto = fetchedTrips[indexPath.row].tripCoverPhoto ,
                    let tripPhotoData: Data = tripPhoto.memPhotoData as Data?{
                    cellTripImageView.image = UIImage(data: tripPhotoData, scale: 1.0)
                    
                }else {
                    print("couldnt unwrap that photo")
                }
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
            if let dest = segue.destination as? MemoryTableViewController{
                dest.parentTrip = selectedTrip
                //dest.tripMemories = selectedTrip?.tripMemories?.allObjects as! [TripMemory]
                dest.currUser = currUser
                dest.title = selectedTrip?.tripTitle
            }
        }
    }
    

}
