//
//  AddTagsViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 12/9/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit
import CoreData

class AddTagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var parentTrip: Trip?
    var currMemory: TripMemory?
    var memoryTags = [Tag]()
    var currUser: User?
    var addMemoryController : AddMemoryTableViewController?
    
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var tagsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if button pressed, SAVE Trip
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AddTagsViewController.saveTags))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddTagsViewController.switchToTab0))
    }
    
    @IBAction func addTag(_ sender: Any) {
        let context = DatabaseController.getContext()
        let newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: context) as? Tag
        
        if let newTag = newTag {
            if !((tagsTextField.text?.isEmpty)!) {
                newTag.tagName = tagsTextField.text
                memoryTags.append(newTag)
                tagsCollection.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsCollection.invalidateIntrinsicContentSize()
    }
    
    //setting number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoryTags.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Pop-up ability to remove tag
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagsCollectionViewCell
        
        cell.tagLabel.text = memoryTags[indexPath.item].tagName
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        
//        cell.frame.size.width = cell.tagLabel.intrinsicContentSize.width + 10
//        cell.frame.size.height = cell.tagLabel.intrinsicContentSize.height + 5
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = collectionView.cellForItem(at: indexPath) as! TagsCollectionViewCell
//        let size = CGSize(width: cell.tagLabel.frame.width, height: cell.tagLabel.frame.size.height)
//        return size
//    }
    
    func saveTags() {
        addMemoryController?.memoryTags = memoryTags
        _ = navigationController?.popViewController(animated: true)
    }
    
    func switchToTab0(){
        _ = navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

}
