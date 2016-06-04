//
//  ContactTableViewController.swift
//  MyContacts
//
//  Created by Chuck Konkol on 6/4/16.
//  Copyright © 2016 Rock Valley College. All rights reserved.
//

import UIKit

//0)
import CoreData
import Foundation


//1)
class ContactTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate,UISearchControllerDelegate {
    
//2)
    var filteredTableData = [NSManagedObject]()
    var resultSearchController = UISearchController()
    
//3)
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        //search for field in CoreData
        let searchPredicate = NSPredicate(format: "fullname CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (contactArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [NSManagedObject]
        
        self.tableView.reloadData()
    }
    
    //4)
    
    var contactArray = [NSManagedObject]()
    
    
    //3) again
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    
    func loaddb()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                contactArray = results
                tableView.reloadData()
            } else {
                print("Could not fetch")
            }
            
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription), \(error.userInfo)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //6)
        self.resultSearchController.delegate = self
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.delegate = self
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            return controller
            
        })()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //7)
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //8)
        
        if (self.resultSearchController.active) {
            return filteredTableData.count
        }
        else {
            return contactArray.count
        }
    }

    //9) Uncomment
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //9a)
        if (self.resultSearchController.active){
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
            let person = filteredTableData[indexPath.row]
            cell.textLabel?.text = person.valueForKey("fullname") as! String?
            cell.textLabel?.text = ">>"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
            let person = contactArray[indexPath.row]
            cell.textLabel?.text = person.valueForKey("fullname") as! String?
            cell.textLabel?.text = ">>"
            return cell
        }
        // was
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        // return cell
    }
    
    //10)
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath)
    {
        print("You selelcted cell #\(indexPath.row)")
    }


    //9) Uncomment
    
    // Override to support conditional editing of the table view.
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    //10)
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //11)
        
        if editingStyle == .Delete
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            if (self.resultSearchController.active)
            {
                context.deleteObject(filteredTableData[indexPath.row])
            }
            else
            {
                    context.deleteObject(contactArray[indexPath.row])
            }
            
        
            var error: NSError? = nil
            do
            {
               try context.save()
               loaddb()
            } catch let error1 as NSError
               {
               error = error1
               print("Unresolved error \(error)")
               abort()
               }
        
        }
        
        /*
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        } 
        */
    }
    

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
    //12)
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //13)
        if segue.identifier == "UpdateContacts"
        {
            if let destination = segue.destinationViewController as? ViewController
            {
                if (self.resultSearchController.active)
                {
                    if let SelectIndex = tableView.indexPathForSelectedRow?.row
                    {
                        let selectedDevice:NSManagedObject = filteredTableData[SelectIndex] as NSManagedObject
                        destination.contactdb = selectedDevice
                        resultSearchController.active = false
                        
                    }
                }
                else
                {
                    if let SelectIndex = tableView.indexPathForSelectedRow?.row
                    {
                        let selectedDevice:NSManagedObject = contactArray[SelectIndex] as NSManagedObjectdestination.contactdb = selectedDevice
                    }
                }
            }
        }
    }

