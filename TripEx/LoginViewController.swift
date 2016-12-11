//
//  LoginViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/30/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    enum authResposes: String {
        case emptyString = "All fields are required. Please try again!"
        case invalidUsername = "That username is already registered. Please try again!"
        case wrongCredentials = "Wrong Username or Password. Please try again!"
        case noUsersRegistered = "There are no users by that name. Please register!"
    }

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedUsers: [User]?
    var loggedInUser: User?
    var activeTextField: UITextField? = nil

    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for field in textFields {
            field.delegate = self
        }

        responseLabel.text = " "
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

    
    @IBAction func loginButton(_ sender: Any) {
        //var isUserUnique = false
        
        //fetch new users first
        fetchData()
        
        if let emailText = emailTextField.text,
            let passwordText = passwordTextField.text {
        
            let emailIndex = emailText.characters.startIndex
            let passwordIndex = passwordText.characters.startIndex
            
            //1.check if users email text is empy
            if(emailText.isEmpty ||  emailText[emailIndex] == " " || passwordText.isEmpty || passwordText[passwordIndex] == " ") {
                print(authResposes.emptyString.rawValue)
                
                responseLabel.text = String(describing: authResposes.emptyString.rawValue) 
                
                /* adds a delay to change the response label to "  "
                let delay = DispatchTime.now() + 10 // change 2 to desired number of seconds
                
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    self.responseLabel.text = ""
                })
                */
            }else {
                //2. authenticate username and password
                
                //unwrap the array and check count
                if let fetchedUsers = fetchedUsers , !(fetchedUsers.isEmpty){
                    for user in fetchedUsers {
                        if (user.userEmail == emailText) {
                            //useremail was found
                            //isUserUnique = true
                            
                            print("that user email is found")
                            //check the password, sorry for not salting/hashing
                            //just to show proof of concept
                            if(user.userPassword == passwordText){
                                loggedInUser = user
                                
                                if let loggedInUser = loggedInUser {
                                    print("\n CURR USER STATUS IS \(loggedInUser.isLoggedIn)\n\n\n USER STATUS IS \(user.isLoggedIn)")
                                    
                                    loggedInUser.isLoggedIn = true
                                    
                                    // Try to update the User contex with data in text fields
                                    // perform initialLogin segue
                                    if(DatabaseController.saveContext() == true) {
                                        print("\nchanged \(loggedInUser.userEmail) logged in status to \(loggedInUser.isLoggedIn)")
                                        
                                        //appDelegate.window?.rootViewController = initialTabBar
                                        performSegue(withIdentifier: "userLoggedIn", sender: self)
                                    }else {
                                        print("oh no that dint saveeeeeee!")
                                    }
                                }
                            }else {
                                //wrong password
                                print(authResposes.wrongCredentials.rawValue)
                                responseLabel.text = String(describing: authResposes.emptyString.rawValue)
                            }
                        }else {
                            print("not the right user to check")
                        }
                    } //end for in loop
                }else {
                    //fetched users is empty meaning, REGISTER
                    print(authResposes.noUsersRegistered.rawValue)
                    responseLabel.text = String(describing: authResposes.noUsersRegistered.rawValue)
                }// end if (there are users)/ else
            } //end if( text fields empty)/else
        } //end if let for textfields
    } //end function
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register", let dest = segue.destination as? SignupViewController {
            dest.title = "Register New User"
        }else if segue.identifier == "userLoggedIn", let dest = segue.destination as? InitialTabBarController {
            dest.currUser = loggedInUser
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
