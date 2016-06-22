//
//  HWList.swift
//  StudentSistant
//
//  Created by Andrew Jones on 6/9/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

func <= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
func >= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}

class HWList: UITableViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    var assignments = [Assignment]()
    
    override func viewWillAppear(animated: Bool) {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        
        let dayOfTheWeek = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.Weekday, fromDate: NSDate()).weekday
        print(dayOfTheWeek)
        
        dateFormatter.dateFormat = "M/dd/YY"
        let convertedCurrentDate = dateFormatter.stringFromDate(currentDate)
        print(convertedCurrentDate)
        
        if let dates = NSKeyedUnarchiver.unarchiveObjectWithFile(SettingsViewController.datesURL.path!) as? [NSDate] {
            if currentDate >= dates[0] && currentDate <= dates[1] {
                if let weekendHW = NSKeyedUnarchiver.unarchiveObjectWithFile(SettingsViewController.weekendURL.path!) as? Bool {
                    if(weekendHW || (!weekendHW && dayOfTheWeek != 1 && dayOfTheWeek != 7)){
                        if assignments.count > 0 && assignments[0].date != convertedCurrentDate {
                            assignments.insert(Assignment(hw: assignments[0].hw, date: convertedCurrentDate)!, atIndex: 0)
                        }else if assignments.count == 0 {
                            assignments.append(Assignment(hw: "", date: convertedCurrentDate)!)
                        }
                    }
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedHW = loadHW() {
            assignments += savedHW
        }
        
        /*
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        
        let dayOfTheWeek = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.Weekday, fromDate: NSDate()).weekday
        print(dayOfTheWeek)
        
        dateFormatter.dateFormat = "M/dd/YY"
        let convertedCurrentDate = dateFormatter.stringFromDate(currentDate)
        print(convertedCurrentDate)
        
        if let dates = NSKeyedUnarchiver.unarchiveObjectWithFile(SettingsViewController.datesURL.path!) as? [NSDate] {
            if currentDate >= dates[0] && currentDate <= dates[1] {
                if let weekendHW = NSKeyedUnarchiver.unarchiveObjectWithFile(SettingsViewController.weekendURL.path!) as? Bool {
                    if(weekendHW || (!weekendHW && dayOfTheWeek != 1 && dayOfTheWeek != 7)){
                        if assignments.count > 0 && assignments[0].date != convertedCurrentDate {
                            assignments.insert(Assignment(hw: assignments[0].hw, date: convertedCurrentDate)!, atIndex: 0)
                        }else if assignments.count == 0 {
                            assignments.append(Assignment(hw: "", date: convertedCurrentDate)!)
                        }
                    }
                }
            }
        }
        */
        navBar.rightBarButtonItem = editButtonItem()
    }
    
    // Allows editing of the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            assignments.removeAtIndex(indexPath.row)
            saveHW()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //Set one column of cells
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HWListCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HWListCell
        
        // Fetches the appropriate grade for the data source layout.
        let assignment = assignments[indexPath.row]
        
        cell.title.text = assignment.date! + ""
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        editing = false
        if segue.identifier == "ShowAssignment" {
            let HWDetailViewController = segue.destinationViewController as! DailyHWViewController
            
            // Get the cell that generated this segue.
            if let selectedGradeCell = sender as? HWListCell {
                let indexPath = tableView.indexPathForCell(selectedGradeCell)!
                let selectedAssignment = assignments[indexPath.row]
                HWDetailViewController.assignment = selectedAssignment
            }
        }
    }
    
    @IBAction func unwindToHWList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DailyHWViewController, assignment = sourceViewController.assignment {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing assignment.
                assignments[selectedIndexPath.row] = assignment
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }else{
                // Add a new assignment.
                let newIndexPath = NSIndexPath(forRow: assignments.count, inSection: 0)
                assignments.append(assignment)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
        saveHW()
    }
    
    
    
    
    //MARK: NSCoding
    
    func saveHW() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(assignments, toFile: Assignment.ArchiveURL.path!) //saves array grades to file defined in Assignment class
        
        if !isSuccessfulSave { //Diagnostic
            print("Save failed")
        }
    }
    
    func loadHW() -> [Assignment]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Assignment.ArchiveURL.path!) as? [Assignment] //gets array grades from file where saved, defined in Assignment class
        
    }
    
}