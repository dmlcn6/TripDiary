//  AddMemoryViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/17/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.

import UIKit
import CoreData

class AddMemoryViewController: UIViewController {

    var parentTrip:Trip?
    var user : User?
    
    
    @IBOutlet weak var tripTitleTextfield: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var titleText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let parentTrip = parentTrip {
            tripTitleTextfield.text = parentTrip.tripTitle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "findLocation"), let destination = segue.destination as? FindLocationViewController {
            destination.addMemoryController = self
        }
        if (segue.identifier == "selectTrip"), let destination = segue.destination as? SelectTripTableViewController {
            destination.addMemoryController = self
            if let userTrips = user?.userTrips {
                destination.trips = Array(userTrips.allObjects) as? [Trip]
                print(destination.trips)
            }
        }
    }
}
