//
//  LoginViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/30/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    @IBAction func loginButton(_ sender: Any) {
        
        //1.check users input vars
        //2. authenticate username and password
        
        //get iniital tab bar
        let initialTabBar = self.storyboard?.instantiateViewController(withIdentifier: "initialTabBarController")
        
        appDelegate.window?.rootViewController = initialTabBar
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
