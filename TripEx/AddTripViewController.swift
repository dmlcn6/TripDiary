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
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    
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
            userPickedImage = pickedImage
            coverImageView.contentMode = .scaleAspectFit
            coverImageView.image = userPickedImage
            
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
        let context = DatabaseController.getContext()
        
        // new trip
        if trip == nil{
            trip = Trip(context: context)
        }
        
        // old trip
        if let trip = trip{
            trip.tripTitle = titleText.text!
            trip.tripLocation = locationText.text!
            trip.tripLatitude = 0
            trip.tripLongitude = 0
            
            
            
            // Try to update the Trip contex with data in text fields
            // perform addTrip segue
            if(DatabaseController.saveContext() == true) {
                print("Saving Trip \(trip.tripTitle)")
                
                //Trip save coverPhoto in bundle
                
                performSegue(withIdentifier: "addTrip", sender: self)
            } else {
                //create an alert to user that Trip didnt save
                let failedAlert = UIAlertController(title: "Save Failed", message: "Trip failed to save in context. Please try again!", preferredStyle: .alert)
                let okMessage = UIAlertAction(title: "Ok", style: .default, handler: nil)
               
                failedAlert.addAction(okMessage)
                present(failedAlert, animated: true, completion: nil)
            }
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
            
            if let dest = segue.destination as? AddMemoryViewController{
                dest.parentTrip = trip
            }
        }
    }
    
    
}
