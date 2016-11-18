//
//  AddMemoryViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/17/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class AddMemoryViewController: UIViewController {

    var parentTrip:Trip?
    
    @IBOutlet weak var titleText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let parentTrip = parentTrip{
            titleText.text = parentTrip.tripTitle
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
