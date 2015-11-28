//
//  ShowsTVC.swift
//  iFandom
//
//  Created by Admin on 11/27/15.
//  Copyright © 2015 Stephen. All rights reserved.
//

import UIKit
import CloudKit


class ShowsTVC: UITableViewController {
    var shows:[CKRecord] = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        let query = CKQuery(recordType: "Show", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        publicData.performQuery(query, inZoneWithID: nil) { results, error in
            if error == nil { // There is no error
                self.shows = results!
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                
            }
            else {
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shows.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        cell.textLabel!.text = shows[indexPath.row].objectForKey("ShowName") as? String
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSeasons"{
            let container = CKContainer.defaultContainer()
            let publicData = container.publicCloudDatabase
            
            let predicate = NSPredicate(format: "PartOf == %@", argumentArray: [shows[tableView.indexPathForSelectedRow!.row].recordID])
            let query = CKQuery(recordType: "Season", predicate: predicate)
            query.sortDescriptors = [NSSortDescriptor(key: "SeasonNum", ascending: true)]
            publicData.performQuery(query, inZoneWithID: nil) { results, error in
                if error == nil { // There is no error
                    let VC = (segue.destinationViewController as! SeasonsTVC)
                    VC.seasons = results!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        VC.tableView.reloadData()
                    })
                }
                else {
                    print(error)
                }
            }
        }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }



}
