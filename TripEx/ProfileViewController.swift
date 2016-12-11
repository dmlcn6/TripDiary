//
//  ProfileViewController.swift
//  TripDiaryFrontEnd
//
//  Created by Thomas Van Doorn  on 11/14/16.
//  Copyright © 2016 Thomas Van Doorn . All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var currUser: User?
    var trips: [Trip]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changes color of the nav bar at the top
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0)
        
        addTripToMap()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let currUser = currUser, currUser.isLoggedIn == true{
            print("\n\nPROFILE \(currUser.userName) logged in \(currUser)\n\n")
            fetchData()
        }else {
            print("\n\nProfile Not logged or nil\n\n")
        }
        
        let backgroundView = UIImageView(frame: UIScreen.main.bounds)
        backgroundView.contentMode = .scaleAspectFit
        backgroundView.clipsToBounds = true
        
        let image = UIImage(named: "imageMasterBackground.jpg")
        
        
        backgroundView.image = image
        
        self.view.insertSubview(backgroundView, at: 0)
        
        self.view.addSubview(backgroundView)
        self.view.sendSubview(toBack: backgroundView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTripToMap() {
        if let trips = trips{
            for trip in trips {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(trip.tripLatitude, trip.tripLongitude)
                annotation.title = trip.tripTitle
                //annotation.subtitle = "815 Olive Street"
                mapView.addAnnotation(annotation)
                
            }
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(38, -92)
        //annotation.title = trip.tripTitle
        //annotation.subtitle = "815 Olive Street"
        mapView.addAnnotation(annotation)
    }
    
    func fetchData() {
        let fetch = NSFetchRequest<Trip>(entityName: "Trip")
        
        //let predicate = NSPredicate(format: "tripTitle == %@", "*")
        
        //fetch.predicate = predicate
        //fetch.fetchLimit = 2
        
        do{
            trips = try DatabaseController.getContext().fetch(fetch)
        }catch let error as NSError {
            print(" hello error \(error.userInfo)")
        }
        
        //collectionView.reloadData()
        
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
