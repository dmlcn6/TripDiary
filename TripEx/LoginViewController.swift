//
//  LoginViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/30/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum authResposes: String {
        case emptyString = "All fields are required. Please try again!"
        case invalidUsername = "That username is already registered. Please try again!"
        case wrongCredentials = " Wrong Username or Password. Please try again!"
    }

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        responseLabel.text = "changed text"
    }


    
    @IBAction func loginButton(_ sender: Any) {
        
        let emailText = emailTextField.text
        let passwordText = passwordTextField.text
        
        
        
        
        
        if let emailText = emailText ,
            let passwordText = passwordText {
        
            let emailIndex = emailText.characters.startIndex
            let passwordIndex = passwordText.characters.startIndex
            
            //1.check if users email text is empy
            if(emailText.isEmpty ||  emailText[emailIndex] == " " || passwordText.isEmpty || passwordText[passwordIndex] == " ") {
                print(authResposes.emptyString.rawValue)
                
                responseLabel.text = String(describing: authResposes.emptyString.rawValue) 
                
                /*
                let delay = DispatchTime.now() + 10 // change 2 to desired number of seconds
                
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    self.responseLabel.text = ""
                })
                */
                
                //2. authenticate username and password
                //get iniital tab bar
                
                 let initialTabBar = self.storyboard?.instantiateViewController(withIdentifier: "initialTabBarController")
                 
                 appDelegate.window?.rootViewController = initialTabBar
                
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
