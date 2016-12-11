//
//  SignupViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 12/1/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class SignupViewController: UIViewController, UITextFieldDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var fnameLabel: UITextField!
    @IBOutlet weak var lnameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    var activeTextField: UITextField? = nil
    var fetchedUsers: [User]?
    var newUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for field in textFields {
        field.delegate = self
            
        fetchData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundView = UIImageView(frame: UIScreen.main.bounds)
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        
        let image = UIImage(named: "imageMasterBackground.jpg")
        
        backgroundView.image = image
        
        self.view.insertSubview(backgroundView, at: 0)
        self.view.addSubview(backgroundView)
        self.view.sendSubview(toBack: backgroundView)
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
                            
                            //sorry for not salting or hashing
                            //just for proof of concept
                            newUser.userPassword = pwText
                            newUser.isLoggedIn = true
                            
                            // Try to update the User contex with data in text fields
                            // perform initialLogin segue
                            if(DatabaseController.saveContext() == true) {
                                print("Creating New User \(newUser.userEmail)")
                                
                                //perform makeshift segue to go to home screen as logged IN user
                                /*get iniital tab bar
                                let initialTabBar = self.storyboard?.instantiateViewController(withIdentifier: "initialTabBarController") as! InitialTabBarController
                                
                                initialTabBar.currUser = newUser
                                appDelegate.window?.rootViewController = initialTabBar
                                */
                                performSegue(withIdentifier: "userRegistered", sender: self)
                            }else {
                                print("\n\noh no that dint saveeeeeee!\n\n")
                            }
                        }
                    // ELSE the use is not unique
                    }else {
                        print("\n\nthat user email \(emailText) is currently registered! Please try again\n\n")
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
                            print("\n\n2Creating New User \(newUser.userEmail)\n\n")
                            
                            //appDelegate.window?.rootViewController = initialTabBar
                            performSegue(withIdentifier: "userRegistered", sender: self)
                        }else{
                            print("\n\noh no that dint saveeeeeee!2\n\n")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userRegistered", let dest = segue.destination as? InitialTabBarController {
            dest.currUser = newUser
        }else if segue.identifier == "backToLogin", let dest = segue.destination as? LoginViewController {
            dest.title = "Login"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        activeTextField?.resignFirstResponder()
    }

}
