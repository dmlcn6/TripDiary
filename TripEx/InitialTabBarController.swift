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
        
        if let currUser = currUser{
            print("\n\nuser \(currUser.userName) is not null\n")
        
        
            if let viewControllers = self.viewControllers{
                //let profileViewController = viewControllers[0] as! ProfileViewController
                //let addTripViewController = viewControllers[1] as! AddTripViewController
                //let tableCollectionViewController = viewControllers[2] as! TableCollectionViewController
                
                var i = 0
                for viewController in viewControllers {
                    print("\(i) \(String(describing: viewController.self))")
                    i += 1
                }
                
                //profileViewController.currUser = currUser
                //addTripViewController.currUser = currUser
                //tableCollectionViewController.currUser = currUser
            }
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
