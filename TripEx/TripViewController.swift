//
//  TripViewController.swift
//  TripDiaryFrontEnd
//
//  Created by Thomas Van Doorn  on 11/14/16.
//  Copyright © 2016 Thomas Van Doorn . All rights reserved.
//

import UIKit

class TripViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Changes Color on the Bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red:90.00, green:200, blue:250, alpha:1.0)
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
