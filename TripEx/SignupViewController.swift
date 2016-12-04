//
//  SignupViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 12/1/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var fnameLabel: UITextField!
    @IBOutlet weak var lnameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    var fetchedUsers: [User]?
    var newUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchData()
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

    
    @IBAction func registerNewUserButton(_ sender: Any) {
        var isUserUnique = true
        
        //get the context to save and modify coredata
        let context = DatabaseController.getContext()
        
        //fetch new users first
        fetchData()
    
        //1. check users input vars
        if let emailText = emailLabel.text, let fnameText = fnameLabel.text, let lnameText = lnameLabel.text, let pwText = passwordLabel.text {
            if (emailText.isEmpty || emailText == " " || fnameText.isEmpty || fnameText == " " || lnameText.isEmpty || lnameText == " " || pwText.isEmpty || pwText == " "){
                
                //if any of the fields are empty or equal to a space then
                //alert user all fields are required
                print("All fields required")
                
            }else {
                //2. check if email is already used
                if let fetchedUsers = fetchedUsers , !(fetchedUsers.isEmpty){
                    
                    for user in fetchedUsers{
                        if (user.userEmail == emailText){
                            //useremail was found
                            isUserUnique = false
                            
                            print("that user email is already taken")
                        }
                    }
                    
                    //the user email was not found
                    if (isUserUnique){
                        //is this nil or nah
                        //create new user
                        newUser = User(context: context)
                        
                        if let newUser = newUser{
                            newUser.userEmail = emailText
                            
                            let fullName = "\(fnameText.capitalized) \(lnameText.capitalized)"
                            newUser.userName = fullName
                            newUser.userPassword = pwText
                            newUser.isLoggedIn = true
                            
                            // Try to update the User contex with data in text fields
                            // perform initialLogin segue
                            if(DatabaseController.saveContext() == true) {
                                print("Creating New User \(newUser.userEmail)")
                                
                                //perform makeshift segue to go to home screen as logged IN user
                                //get iniital tab bar
                                let initialTabBar = self.storyboard?.instantiateViewController(withIdentifier: "initialTabBarController") as! InitialTabBarController
                                
                                initialTabBar.currUser = newUser
                                appDelegate.window?.rootViewController = initialTabBar
                            }else {
                                print("oh no that dint saveeeeeee!")
                            }
                        }
                    // ELSE the use is not unique
                    }else {
                        print("that user email \(emailText) is currently registered! Please try again")
                    }
                }else {
                    // create new User
                    //create new user
                    newUser = User(context: context)
                    
                    if let newUser = newUser{
                        newUser.userEmail = emailText
                        
                        let fullName = "\(fnameText.capitalized) \(lnameText.capitalized)"
                        newUser.userName = fullName
                        newUser.userPassword = pwText
                        newUser.isLoggedIn = true
                        
                        // Try to update the User contex with data in text fields
                        // perform initialLogin segue
                        if(DatabaseController.saveContext() == true) {
                            print("2Creating New User \(newUser.userEmail)")
                            
                            //perform makeshift segue to go to home screen as logged IN user
                            //get iniital tab bar
                            let initialTabBar = self.storyboard?.instantiateViewController(withIdentifier: "initialTabBarController") as! InitialTabBarController
                            
                            initialTabBar.currUser = newUser
                            appDelegate.window?.rootViewController = initialTabBar
                        }else{
                            print("oh no that dint saveeeeeee!2")
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
