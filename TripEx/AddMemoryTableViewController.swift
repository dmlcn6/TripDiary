//
//  AddMemoryTableViewController.swift
//  TripEx
//
//  Created by Dominic Pilla on 12/9/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class AddMemoryTableViewController: UITableViewController {
    
    var parentTrip: Trip?
    var currUser: User?
    var currMemory: TripMemory?
    var userPickedImage: UIImage?
    
    var memoryTitle : String?
    var memoryNote : String?
    var memoryTripTitle : String?
    var memoryLocation : String?
    var memoryTags : [Tag]?
    var memoryPhotos : [MemoryPhoto]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentTrip = parentTrip {
            memoryTripTitle = parentTrip.tripTitle
        }
        
        if let memoryLocation = memoryLocation, let memoryTripTitle = memoryTripTitle {
            print("Location: \(memoryLocation) and Trip Title: \(memoryTripTitle)")
        } else {
            print("Location and Trip Title are both empty")
        }
        
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.reloadData()
        
        //Add NEXT button
        //if button pressed, SAVE Trip
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AddMemoryTableViewController.saveMemory))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Refresh the table every time this view appears to load in new data
        tableView.reloadData()
        
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "title") as! MemoryTitleCell

            memoryTitle = cell.memoryTitleTextField.text
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "note") as! MemoryNoteCell
            
            memoryNote = cell.memoryNoteTextArea.text
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tripTitle") as! MemoryTripTitleCell
            
            cell.memoryTripTitle.text = memoryTripTitle
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "location") as! MemoryLocationCell
            
            cell.memoryLocation.text = memoryLocation
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actions") as! MemoryActionCell
            
            return cell
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "findLocation"), let destination = segue.destination as? FindLocationViewController {
            destination.addMemoryController = self
        }
        if (segue.identifier == "addTags"), let destination = segue.destination as? AddTagsViewController {
            destination.currUser = currUser
            destination.currMemory = currMemory
        }
    }
    
    // If the User hits the NEXT button in Navigation
    func saveMemory(){
        print("\n\nADD MEMORY LOGGED STATUS: \(currUser?.isLoggedIn)\n\n")
        
        // if title text is filled in
        if let titleText = memoryTitle {
            
            //if user logged In
            if let currUser = currUser, currUser.isLoggedIn == true {
                let context = DatabaseController.getContext()
                
                // new memory
                if currMemory == nil{
                    currMemory = NSEntityDescription.insertNewObject(forEntityName: "TripMemory", into: context) as? TripMemory
                }
                
                // old memory
                if let currMemory = currMemory {
                    currMemory.memTitle = titleText
                    currMemory.memNote = memoryNote
                    
                    let currentDate = NSDate()
                    currMemory.memDate = currentDate
                    
                    /*
                     if let userPickedImage = userPickedImage,
                     let imageData = UIImagePNGRepresentation(userPickedImage) as NSData?,
                     let imageSet:MemoryPhoto = NSEntityDescription.insertNewObject(forEntityName: "MemoryPhoto", into: context) as? MemoryPhoto{
                     image.memPhotoData = imageData
                     
                     //adds trip to currUser
                     trip.tripCoverPhoto = image
                     
                     }else{
                     print("\n\nwtf happend? \(userPickedImage)")
                     }
                     */
                    if let parentTrip = parentTrip{
                        print(parentTrip.tripMemories?.count as Any)
                        parentTrip.addToTripMemories(currMemory)
                        
                    }
                    
                    // Try to update the Trip contex with data in text fields
                    // perform addTrip segue
                    if(DatabaseController.saveContext() == true) {
                        print("\n\nSaving user \(currUser.userEmail) TripMemory count \(parentTrip?.tripMemories?.count).count)")
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self,selector: #selector(switchToTab0),userInfo: nil, repeats: false)
                        
                        
                    } else {
                        //create an alert to user that Trip didnt save
                        //presentFailedAlert("Trip failed to save.", "Trip failed to save in context. Please try again!", nil)
                        print("\n\n DINTTT Save MEMORY \(currUser.userEmail) TripMemory \(parentTrip?.tripMemories?.count).count)\n\n")
                    }
                }
            }else {
                //if there is no current user logged iN
                //create an alert to user that Trip didnt save
                //create an alert to user that Trip didnt save
                //presentFailedAlert("Trips will only save for logged in users.", "Please go to Profile to login or register!", "Login")
                print("im getting no user")
            }
        } else {
            print("I am not getting a title!")
        }
    }
    
    func switchToTab0(){
        tabBarController?.selectedIndex = 0
    }
}
