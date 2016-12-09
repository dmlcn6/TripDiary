//  AddMemoryViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/17/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.

import UIKit
import CoreData

class AddMemoryViewController: UIViewController {

    var parentTrip: Trip?
    var currUser: User?
    var currMemory: TripMemory?
    var userPickedImage: UIImage?
    
    
    @IBOutlet weak var tripTitleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let parentTrip = parentTrip {
            tripTitleTextField.text = parentTrip.tripTitle
        }
        
        //Add NEXT button
        //if button pressed, SAVE Trip
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AddMemoryViewController.saveMemory))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // If the User hits the NEXT button in Navigation
    func saveMemory(){
        print("\n\nADD MEMORY LOGGED STATUS: \(currUser?.isLoggedIn)\n\n")
        
        // if title text is filled in
        if let titleText = titleTextField.text {
            
            //if user logged In
            if let currUser = currUser, currUser.isLoggedIn == true{
                let context = DatabaseController.getContext()
                
                // new memory
                if currMemory == nil{
                    currMemory = NSEntityDescription.insertNewObject(forEntityName: "TripMemory", into: context) as? TripMemory
                }
                
                // old memory
                if let currMemory = currMemory {
                    currMemory.memTitle = titleText
                    currMemory.memNote = noteTextView.text
                    
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
        }
    }
    
    func switchToTab0(){
        tabBarController?.selectedIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "findLocation"), let destination = segue.destination as? FindLocationViewController {
//            destination.addMemoryController = self
//        }
//        if (segue.identifier == "selectTrip"), let destination = segue.destination as? SelectTripTableViewController {
//            destination.addMemoryController = self
//            /*
//            if let userTrips = user?.userTrips {
//                destination.trips = Array(userTrips.allObjects) as? [Trip]
//            }
//            */
//        }
//    }
}
