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
    
    var currUser:User?
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
        
        //Add NEXT button that saves a Trip
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(AddTripViewController.saveTrip))
        
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
    
    //If the User hits the NEXT button in Navigation
    func saveTrip(){
        let context = DatabaseController.getContext()
        
        
        //new trip
        if trip == nil{
            trip = Trip(context: context)
        }
        
        //old trip
        if let trip = trip{
            trip.tripTitle = titleText.text!
            trip.tripLocation = locationText.text!
            trip.tripLatitude = 0
            trip.tripLongitude = 0
            //trip.tripMemories
            
            //fetch trip cover photo from bundle
            
            
            do{
                try context.save()
                
                performSegue(withIdentifier: "add", sender: self)
            }catch let error as NSError {
                print("Error Saving \(error.userInfo)")
            }

        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "add" {
            //saveTrip()
            print("it saved")
            
            if let dest = segue.destination as? AddMemoryViewController{
                dest.parentTrip = trip
            }
        }
    
    }
    

}
