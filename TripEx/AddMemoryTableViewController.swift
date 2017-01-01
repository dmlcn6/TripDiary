//
//  AddMemoryTableViewController.swift
//  TripEx
//
//  Created by Dominic Pilla on 12/9/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class AddMemoryTableViewController: UITableViewController, UIImagePickerControllerDelegate {
    
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
    
    let imagePicker = UIImagePickerController()
    
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
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        tableView.reloadData()
        
        //Add NEXT button
        //if button pressed, SAVE Trip
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AddMemoryTableViewController.saveMemory))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Refresh the table every time this view appears to load in new data
        tableView.reloadData()
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.title = "Add Memory"
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
    
    //presents the photoLibrary for selecting without editing
    func openPhotoLibrary() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //BUTTON CLICKED TO PRESENT PHOTOLIBRARY
    @IBAction func presentPhotoLibrary(_ sender: Any) {
        openPhotoLibrary()
    }
    
    //IF THE USER PICKS AN IMAGE
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //grab the users selected image from the PhotoLibrary
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //if let coverImageView = coverImageView {
                userPickedImage = pickedImage
                //coverImageView.contentMode = .scaleAspectFit
                //coverImageView.image = userPickedImage
            //}
        }
        dismiss(animated: true, completion: nil)
    }
    
    //User cancels the PhotoLibrary.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // If the User hits the Save button in Navigation
    func saveMemory(){
        print("\n\nADD MEMORY LOGGED STATUS: \(currUser?.isLoggedIn)\n\n")
        
        // if title text is filled in
        if let titleText = memoryTitle {
            
            //if user logged In
            if let currUser = currUser, currUser.isLoggedIn == true {
                let context = DatabaseController.getContext()
                
                // new memory
                if currMemory == nil {
                    currMemory = NSEntityDescription.insertNewObject(forEntityName: "TripMemory", into: context) as? TripMemory
                }
                
                // old memory
                if let currMemory = currMemory {
                    print("MEMORY \(currMemory.memTitle) HAS  \(currMemory.memPhotos?.count) # PHOTOS\n\n")
                    currMemory.memTitle = titleText
                    currMemory.memNote = memoryNote
                    
                    if let memoryTags = memoryTags {
                        for tag in memoryTags {
                            currMemory.memTags?.adding(tag)
                        }
                    }
                    
                    let currentDate = NSDate()
                    currMemory.memDate = currentDate
                    
                    
                    if let userPickedImage = userPickedImage,
                    let imageData = UIImagePNGRepresentation(userPickedImage) as NSData?,
                    let image:MemoryPhoto = NSEntityDescription.insertNewObject(forEntityName: "MemoryPhoto", into: context) as? MemoryPhoto {

                        image.memPhotoData = imageData

                        //adds image to currMemory
                        currMemory.addToMemPhotos(image)
                        print("\n\nMEMORY \(currMemory.memTitle) HAS  \(currMemory.memPhotos?.count) # PHOTOS\n\n")
                    }else {
                        print("\n\nwtf happend? \(userPickedImage)")
                    }
                    
                    
                    //add currMemory to parent trip
                    if let parentTrip = parentTrip{
                        print("\n\nPARENT HAS # \(parentTrip.tripMemories?.count) TRIPS\n\n")
                        parentTrip.addToTripMemories(currMemory)
                        
                    }
                    
                    // Try to update the Trip contex with data in text fields
                    // perform addTrip segue
                    if(DatabaseController.saveContext() == true) {
                        print("\n\nSaving user \(currUser.userEmail) TripMemory count for parent trip is \(parentTrip?.tripMemories?.count).count)")
                        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "findLocation"), let destination = segue.destination as? FindLocationViewController {
            destination.addMemoryController = self
            destination.identifier = "findLocation"
        }
        if (segue.identifier == "addTags"), let destination = segue.destination as? AddTagsViewController {
            destination.currUser = currUser
            destination.currMemory = currMemory
            destination.addMemoryController = self
        }
    }
}
