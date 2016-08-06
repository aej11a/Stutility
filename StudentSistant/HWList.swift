//
//  HWList.swift
//  StudentSistant
//
//  Created by Andrew Jones on 6/9/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

func <= (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
func >= (lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}

class HWList: UITableViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    var assignments = [Assignment]()
    
    override func viewWillAppear(_ animated: Bool) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        let dayOfTheWeek = Calendar(identifier: Calendar.Identifier.gregorian).component(.weekday, from: Date())
        print(dayOfTheWeek)
        
        dateFormatter.dateFormat = "M/dd/YY"
        let convertedCurrentDate = dateFormatter.string(from: currentDate)
        print(convertedCurrentDate)
        
        //Adds an assignment based on date comparisons
        if let dates = NSKeyedUnarchiver.unarchiveObject(withFile: SettingsViewController.datesURL.path) as? [Date] {
            if currentDate >= dates[0] && currentDate <= dates[1] {
                if let weekendHW = NSKeyedUnarchiver.unarchiveObject(withFile: SettingsViewController.weekendURL.path) as? Bool {
                    if(weekendHW || (!weekendHW && dayOfTheWeek != 1 && dayOfTheWeek != 7)){
                        if assignments.count > 0 && assignments[0].date != convertedCurrentDate {
                            assignments.insert(Assignment(hw: assignments[0].hw, date: convertedCurrentDate)!, at: 0)
                        }else if assignments.count == 0 {
                            assignments.append(Assignment(hw: "", date: convertedCurrentDate)!)
                        }
                    }
                }
            }
        }
        
        //adds assignment on first launch of app
        if assignments.count == 0 {
            assignments.append(Assignment(hw: "", date: convertedCurrentDate)!)
            saveHW()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedHW = loadHW() {
            assignments += savedHW
        }
        navBar.rightBarButtonItem = editButtonItem
    }
    
    // Allows editing of the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            assignments.remove(at: (indexPath as NSIndexPath).row)
            saveHW()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //Set one column of cells
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HWListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HWListCell
        
        // Fetches the appropriate grade for the data source layout.
        let assignment = assignments[(indexPath as NSIndexPath).row]
        
        cell.title.text = assignment.date! + ""
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        isEditing = false
        if segue.identifier == "ShowAssignment" {
            let HWDetailViewController = segue.destination as! DailyHWViewController
            
            // Get the cell that generated this segue.
            if let selectedGradeCell = sender as? HWListCell {
                let indexPath = tableView.indexPath(for: selectedGradeCell)!
                let selectedAssignment = assignments[(indexPath as NSIndexPath).row]
                HWDetailViewController.assignment = selectedAssignment
            }
        }
    }
    
    @IBAction func unwindToHWList(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DailyHWViewController, let assignment = sourceViewController.assignment {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing assignment.
                assignments[(selectedIndexPath as NSIndexPath).row] = assignment
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                // Add a new assignment.
                let newIndexPath = IndexPath(row: assignments.count, section: 0)
                assignments.append(assignment)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
        }
        saveHW()
    }
    
    
    
    
    //MARK: NSCoding
    
    func saveHW() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(assignments, toFile: Assignment.ArchiveURL.path) //saves array grades to file defined in Assignment class
        
        if !isSuccessfulSave { //Diagnostic
            print("Save failed")
        }
    }
    
    func loadHW() -> [Assignment]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Assignment.ArchiveURL.path) as? [Assignment] //gets array grades from file where saved, defined in Assignment class
        
    }
    
}
