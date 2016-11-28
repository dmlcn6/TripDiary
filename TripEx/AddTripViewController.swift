//
//  AddTripViewController.swift
//  TripDiaryFrontEnd
//
//  Created by Thomas Van Doorn  on 11/14/16.
//  Copyright © 2016 Thomas Van Doorn . All rights reserved.
//

import UIKit
import CoreData

class AddTripViewController: UIViewController {

    var trip:Trip?
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        
        //Add Save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(AddTripViewController.saveTrip))

        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(AddTripViewController.saveTrip))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveTrip(){
        let context = DatabaseController.getContext()
        
        //new trip
        if trip == nil{
            trip = Trip(context: context)
        }
        
        //old task
        if let trip = trip{
            trip.tripTitle = titleText.text!
            trip.tripLocation = locationText.text!
            trip.tripLatitude = 0
            trip.tripLongitude = 0
            
            //trip.tripMemories
            
            
            do{
                try context.save()
                
                performSegue(withIdentifier: "add", sender: self )
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
        else if segue.identifier == "show" {
            print("it showed")
            
            if let dest = segue.destination as? TripViewController{
                dest.title = "Trip Cover Photo"
            }

        }
    
    }
    

}
