//
//  AddTripViewController.swift
//  TripDiaryFrontEnd
//
//  Created by Thomas Van Doorn  on 11/14/16.
//  Copyright © 2016 Thomas Van Doorn . All rights reserved.
//

import UIKit
import CoreData

class AddTripViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currUser: User?
    var trip:Trip?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var tripLatitude : Double = 0
    var tripLongitude : Double = 0
    
    var userPickedImage: UIImage?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        //Add NEXT button 
        //if button pressed, SAVE Trip
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(AddTripViewController.saveTrip))
        
        //Changes Color on the Bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
       
        if let currUser = currUser, currUser.isLoggedIn == true{
            print("\n\nADDTRIP \(currUser.userName) logged in \(currUser)\n\n")
        }else {
            print("\n\nADDTRIP Not logged or nil\n\n")
            
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
            if let coverImageView = coverImageView {
                userPickedImage = pickedImage
                coverImageView.contentMode = .scaleAspectFit
                coverImageView.image = userPickedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    //User cancels the PhotoLibrary.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        //after cancelling a picking, pop
        // to AddTripViewController
        /*
         if let navigationController = navigationController{
            let viewControllers: [UIViewController] = navigationController.viewControllers
            for aViewController in viewControllers {
                if(aViewController is AddTripViewController){
                    navigationController.popToViewController(aViewController, animated: true);
                }
            }
         }
        */
    }
    
    // If the User hits the NEXT button in Navigation
    func saveTrip(){
        //if user logged In
        print("\(currUser?.isLoggedIn)")
        if let currUser = currUser, currUser.isLoggedIn == true{
            let context = DatabaseController.getContext()
            
            // new trip
            if trip == nil{
                trip = Trip(context: context)
                
            }
            
            // old trip
            if let trip = trip{
                trip.tripTitle = titleText.text
                trip.tripLocation = locationText.text
                trip.tripLatitude = self.tripLatitude
                trip.tripLongitude = self.tripLongitude
                
                let currentDate = NSDate()
                trip.tripDate = currentDate
                
                if let userPickedImage = userPickedImage,
                    let imageData = UIImagePNGRepresentation(userPickedImage) as NSData?,
                    let image:MemoryPhoto = NSEntityDescription.insertNewObject(forEntityName: "MemoryPhoto", into: context) as? MemoryPhoto{
                    image.memPhotoData = imageData
                    
                    //adds trip to currUser
                    trip.tripCoverPhoto = image

                }else{
                    print("\n\nwtf happend? \(userPickedImage)")
                }
                
                currUser.addToUserTrips(trip)
                
                // Try to update the Trip contex with data in text fields
                // perform addTrip segue
                if(DatabaseController.saveContext() == true) {
                    print("\n\nSaving user \(currUser.userEmail) \n\nTrip \(currUser.userTrips?.allObjects.count).tripTitle)")
                    performSegue(withIdentifier: "addTrip", sender: self)
                } else {
                    //create an alert to user that Trip didnt save
                    presentFailedAlert("Trip failed to save.", "Trip failed to save in context. Please try again!", nil)
                }
            }
        }else {
            //if there is no current user logged iN
            //create an alert to user that Trip didnt save
            //create an alert to user that Trip didnt save
            presentFailedAlert("Trips will only save for logged in users.", "Please go to Profile to login or register!", "Login")
        }
    }
    
    func presentFailedAlert(_ customTitle:String, _ customMessage:String, _ customAlertTitle:String?){
        //create an alert to user that Trip didnt save
        let failedAlert = UIAlertController(title: customTitle, message: customMessage, preferredStyle: .alert)
        let okMessage = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        if(customAlertTitle == nil){
            failedAlert.addAction(okMessage)
            present(failedAlert, animated: true, completion: nil)
        }else {
            let registerMessage = UIAlertAction(title: customAlertTitle, style: .default, handler: {
            (action) -> Void in
                //perform makeshift segue to go to home screen as logged IN user
                //get iniital tab bar
                 let initialLogin = self.storyboard?.instantiateViewController(withIdentifier: "initialLoginScreen") as! LoginViewController
                
                 self.appDelegate.window?.rootViewController = initialLogin
                
            })
            
            failedAlert.addAction(okMessage)
            failedAlert.addAction(registerMessage)
            present(failedAlert, animated: true, completion: nil)
        }
        
       

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addTrip" {
            //saveTrip()
            print("it saved")
            
            if let dest = segue.destination as? AddMemoryTableViewController {
                dest.parentTrip = trip
                dest.currUser = currUser
            }
        }
        
        if (segue.identifier == "findTripLocation"), let destination = segue.destination as? FindLocationViewController {
            destination.addTripController = self
            destination.identifier = "findTripLocation"
        }
    }
}
