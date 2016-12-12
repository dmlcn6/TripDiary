//
//  AddTagsViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 12/9/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class AddTagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var parentTrip: Trip?
    var currMemory: TripMemory?
    var memoryTags = [Tag]()
    var currUser: User?
    
    let columnNum: CGFloat = 3 //use number of columns instead of a static maximum cell width
    var cellWidth: CGFloat = 0
    
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var tagsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Add Done button
        //if button pressed, SAVE Trip
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AddTagsViewController.saveTags))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddTagsViewController.switchToTab0))
        
        checkTripMemsTags()
        
        if memoryTags.isEmpty{
            print("No Tags Yet")
        }else {
            for tag in memoryTags {
                print("\n\ntag Name is: \(tag.tagName)\n\n")
            }
        }
        
        if let flowLayout = tagsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columnNum - 1)
            let totalCellAvailableWidth = tagsCollection.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - spaceBetweenCells
            cellWidth = floor(totalCellAvailableWidth / columnNum);
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        //recalculate the collection view layout when the view layout changes
        tagsCollection.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func addTag(_ sender: Any) {
        let context = DatabaseController.getContext()
        let newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: context) as? Tag
        
        if let newTag = newTag {
            if !((tagsTextField.text?.isEmpty)!) {
                newTag.tagName = tagsTextField.text
                memoryTags.append(newTag)
                
                currMemory?.memTags?.addingObjects(from: memoryTags)
                
                tagsCollection.reloadData()
            }
        }
    }
    
    func checkTripMemsTags() {
        if let currMemory = currMemory {
            memoryTags = currMemory.memTags?.allObjects as! [Tag]
        }
        print("TRIP MEM TAGS#: \(memoryTags.count)\n\n")
    }
    
    //setting number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoryTags.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagsCollectionViewCell
        
        cell.tagLabel.text = memoryTags[indexPath.item].tagName
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        cell.tagLabel.preferredMaxLayoutWidth = 80
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return
//    }

    
    // If the User hits the NEXT button in Navigation
    func saveTags(){
        print("\n\nADD Tags LOGGED STATUS: \(currUser?.isLoggedIn)\n\n")
        
        // if title text is filled in
        if let tagsText = tagsTextField.text {
            
            //if user logged In
            if let currUser = currUser, currUser.isLoggedIn == true{
                let context = DatabaseController.getContext()
                
                // create new Tag
                let newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: context) as? Tag
                
                // old memory
                if let newTag = newTag {
                    //add content to current tag
                    newTag.tagName = tagsText
                    
                    if let currMemory = currMemory{
                        currMemory.addToMemTags(newTag)
                        
                        // Try to update the TripMemory contex with data in text fields
                        // perform popViewController segue
                        if(DatabaseController.saveContext() == true) {
                            print("\n\nSAVING USER \(currUser.userEmail) \\ Tags.count# is \(currMemory.memTags?.count))")
                            
                            Timer.scheduledTimer(timeInterval: 0.2, target: self,selector: #selector(switchToTab0),userInfo: nil, repeats: false)
                            
                            
                        } else {
                            //create an alert to user that Trip didnt save
                            //presentFailedAlert("Trip failed to save.", "Trip failed to save in context. Please try again!", nil)
                            print("\n\n DINTTT Save MEMORY \(currUser.userEmail) TripMemoryTag# is \(currMemory.memTags?.count).count)\n\n")
                        }
                    }
                }
            }else {
                //if there is no current user logged iN
                //create an alert to user that Trip didnt save
                //create an alert to user that Trip didnt save
                //presentFailedAlert("Trips will only save for logged in users.", "Please go to Profile to login or register!", "Login")
                print("n\nim getting no user\n\n")
            }
        }else{
            //this else is if the tagsTextField is empty
            print("\n\nEMPTY TAGS TEXT FIELD\n\n")
        
        }
    }
    
    func switchToTab0(){
        //tabBarController?.selectedIndex = 0
        _ = navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hideKeyBoardOnTouch(_ sender: Any) {
        tagsTextField.resignFirstResponder()
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
