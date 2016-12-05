//
//  InitialTabBarController.swift
//  TripEx
//
//  Created by Darryl Lopez on 12/3/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class InitialTabBarController: UITabBarController {

    var currUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let navControllers = self.viewControllers {
            var i = 0
            for navController in navControllers {
                print("\(i) \(String(describing: navController.self))")
                print("navcontroller.count \(navController.childViewControllers.count) \(navController.childViewControllers.first?.description)")
                i += 1
            }
            
            if let tableCollectionViewController = navControllers[0].childViewControllers.first as? TableCollectionViewController,
                let addTripViewController = navControllers[0].childViewControllers.first as? AddTripViewController,
                let profileViewController = navControllers[0].childViewControllers.first as? ProfileViewController {
                
                tableCollectionViewController.currUser = currUser
                addTripViewController.currUser = currUser
                profileViewController.currUser = currUser
            }else {
                print("This many NAVS \(navControllers.count) = no data sent")
            }
        }
        
        if let currUser = currUser{
            print("\n\nuser \(currUser.userName) is not null\n")
        
        }else{
            print("\n\nuser must be null")
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
