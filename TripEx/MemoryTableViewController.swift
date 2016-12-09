//
//  MemoryTableViewController.swift
//  TripEx
//
//  Created by Darryl Lopez on 12/8/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class MemoryTableViewController: UITableViewController {
    
    var parentTrip: Trip?
    var tripMemories = [TripMemory]()
    var currUser: User?
    var cellCount: Int = 1
    var index = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        checkTripMems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
    func checkTripMems() {
        if let parentTrip = parentTrip{
            tripMemories = parentTrip.tripMemories?.allObjects as! [TripMemory]
        }
        print("TRIP MEM#: \(tripMemories.count)\n\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(tripMemories.isEmpty){
            cellCount = 0
            return 1
        }else{
            return tripMemories.count

        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memorycell", for: indexPath) as! MemoryTableViewCell

        // Configure the cell...
        
        if (cellCount == 0){
            cell.locationTextField.text = "NO MEMORIES"
        }else {
            cell.titleTextField.text = tripMemories[indexPath.row].memTitle
            cell.locationTextField.text = String(describing: tripMemories[indexPath.row].memDate)
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
