//  FindLocationViewController.swift
//  TripEx
//
//  Created by Dominic Pilla on 12/2/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.

import UIKit
import MapKit

class FindLocationViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var addMemoryController : AddMemoryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 38.940406, longitude: -92.32788)
        let span = MKCoordinateSpanMake(0.08, 0.08)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.map.setRegion(region, animated: true)
    }
//art was here
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
        Credit for Map Search Function by: http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
    */
    @IBAction func searchLocation(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.map.annotations.count != 0 {
            annotation = self.map.annotations[0]
            self.map.removeAnnotation(annotation)
        }
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text?.capitalized
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.map.centerCoordinate = self.pointAnnotation.coordinate
            self.map.addAnnotation(self.pinAnnotationView.annotation!)
            
            self.addMemoryController?.locationTextField.text = self.pointAnnotation.title
        }
    }
}
