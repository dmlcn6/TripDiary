//
//  LoginViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/30/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    enum authResposes: String {
        case emptyString = "All fields are required. Please try again!"
        case invalidUsername = "That username is already registered. Please try again!"
        case wrongCredentials = " Wrong Username or Password. Please try again!"
        case userNotFound = "User Not Found. Please register!"
    }
    
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedUsers: [User]?
    var loggedUser: User?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        responseLabel.text = " "
    }
    
    func fetchData() {
        let fetch = NSFetchRequest<User>(entityName: "User")
        
        //let predicate = NSPredicate(format: "tripTitle == %@", "*")
        
        //fetch.predicate = predicate
        //fetch.fetchLimit = 2
        
        do{
            fetchedUsers = try DatabaseController.getContext().fetch(fetch)
        }catch let error as NSError {
            print(" hello USER FETCH error \(error.userInfo)")
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        //fetch new users first
        fetchData()
        
        //1. check users input vars
        if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
            
            let emailIndex = emailText.characters.startIndex
            let passwordIndex = passwordText.characters.startIndex
            
            if (emailText.isEmpty || emailText[emailIndex] == " " || passwordText.isEmpty || passwordText[passwordIndex] == " "){
                
                print(authResposes.emptyString.rawValue)
                responseLabel.text = String(describing: authResposes.emptyString.rawValue)
            
                /*
                 let delay = DispatchTime.now() + 10 // change 2 to desired number of seconds
                 
                 DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                 self.responseLabel.text = ""
                 })
                 */
            }else {
                if let fetchedUsers = fetchedUsers, !(fetchedUsers.isEmpty) {
                    for user in fetchedUsers{
                        if (user.userEmail == emailText){
                            //useremail was found
                            if(user.userPassword == passwordText) {
                                
                                loggedUser = user
                                
                                if let loggedUser = loggedUser{
                                    
                                    print("\nprinting state of logged in \(loggedUser.isLoggedIn)\n")
                                    
                                    //set user logged in status
                                    loggedUser.isLoggedIn = true
                                    
                                    //save state of logged in user
                                    if(DatabaseController.saveContext() == true) {
                                        print("loggin in user \(loggedUser.userEmail)")
                                        //send to iinitial tab bar
                                        performSegue(withIdentifier: "loginUser", sender: self)
                                    }else {
                                        print("oh no that dint saveeeeeee!")
                                    }
                                }
                            }else{
                                print(authResposes.wrongCredentials.rawValue)
                                responseLabel.text = String(describing: authResposes.wrongCredentials.rawValue)
                            }
                        }else {
                            //fetched user array is empty, there are no users
                            print(authResposes.userNotFound.rawValue)
                            responseLabel.text = String(describing: authResposes.userNotFound.rawValue)
                        }
                    }
                } else{
                    //fetched user array is empty, there are no users
                    print(authResposes.userNotFound.rawValue)
                    responseLabel.text = String(describing: authResposes.userNotFound.rawValue)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register",
            let dest = segue.destination as? SignupViewController {
                dest.title = "Register New User"
        }else if (segue.identifier == "loginUser"){
            if let dest = segue.destination as? InitialTabBarController{
            
                dest.title = "My Trips"
                dest.currUser = loggedUser
                
                let initialTabBar = self.storyboard?.instantiateViewController(withIdentifier: "initialTabBarController")
                
                appDelegate.window?.rootViewController = initialTabBar

            }
            
        }
    }
    
}
