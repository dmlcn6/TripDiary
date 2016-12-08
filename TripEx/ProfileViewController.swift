//
//  ProfileViewController.swift
//  TripDiaryFrontEnd
//
//  Created by Thomas Van Doorn  on 11/14/16.
//  Copyright © 2016 Thomas Van Doorn . All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var currUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changes color of the nav bar at the top
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currUser = currUser, currUser.isLoggedIn == true{
            print("\n\nPROFILE \(currUser.userName) logged in \(currUser)\n\n")
        }else {
            print("\n\nADDTRIP Not logged or nil\n\n")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
