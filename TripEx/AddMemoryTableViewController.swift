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
    
    var memoryTitleCell : MemoryTitleCell?
    var memoryNoteCell : MemoryNoteCell?
    var memoryTripTitleCell : MemoryTripTitleCell?
    var memoryLocationCell : MemoryLocationCell?
    var memoryActionCell : MemoryActionCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentTrip = parentTrip {
            memoryTripTitleCell?.memoryTripTitle.text = parentTrip.tripTitle
        }
        
        //Add NEXT button
        //if button pressed, SAVE Trip
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AddMemoryViewController.saveMemory))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "title") as! MemoryTitleCell
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "note") as! MemoryNoteCell
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tripTitle") as! MemoryTripTitleCell
            cell.memoryTripTitle.text = parentTrip?.tripTitle
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "location") as! MemoryLocationCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actions") as! MemoryActionCell
            
            return cell
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "findLocation"), let destination = segue.destination as? FindLocationViewController {
            destination.addMemoryController = self
        }
        if (segue.identifier == "selectTrip"), let destination = segue.destination as? SelectTripTableViewController {
            destination.addMemoryController = self
            /*
             if let userTrips = user?.userTrips {
             destination.trips = Array(userTrips.allObjects) as? [Trip]
             }
             */
        }
    }
    
    // If the User hits the NEXT button in Navigation
    func saveMemory(){
        print("\n\nADD MEMORY LOGGED STATUS: \(currUser?.isLoggedIn)\n\n")
        
        // if title text is filled in
        if let titleText = memoryTitleCell?.memoryTitleTextField.text {
            
            //if user logged In
            if let currUser = currUser, currUser.isLoggedIn == true{
                let context = DatabaseController.getContext()
                
                // new memory
                if currMemory == nil{
                    currMemory = TripMemory(context: context)
                }
                
                // old memory
                if let currMemory = currMemory {
                    currMemory.memTitle = titleText
                    currMemory.memNote = memoryNoteCell?.memoryNoteTextArea.text
                    
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
                        var addingMemory:TripMemory = NSEntityDescription.insertNewObject(forEntityName: "TripMemory", into: context) as! TripMemory
                        addingMemory = currMemory
                        
                        parentTrip.addToTripMemories(addingMemory)
                    }
                    
                    // Try to update the Trip contex with data in text fields
                    // perform addTrip segue
                    if(DatabaseController.saveContext() == true) {
                        print("\n\nSaving user \(currUser.userEmail) TripMemory \(parentTrip?.tripMemories?.count).count)")
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self,selector: #selector(switchToTab0),userInfo: nil, repeats: false)
                        
                        
                    } else {
                        //create an alert to user that Trip didnt save
                        //presentFailedAlert("Trip failed to save.", "Trip failed to save in context. Please try again!", nil)
                        print("\n\n DINTTT Save MEMORY \(currUser.userEmail) TripMemory \(currUser.userTrips?.allObjects.count).count)\n\n")
                    }
                }
            }else {
                //if there is no current user logged iN
                //create an alert to user that Trip didnt save
                //create an alert to user that Trip didnt save
                //presentFailedAlert("Trips will only save for logged in users.", "Please go to Profile to login or register!", "Login")
            }
        }
    }
    
    func switchToTab0(){
        tabBarController?.selectedIndex = 0
    }
}
