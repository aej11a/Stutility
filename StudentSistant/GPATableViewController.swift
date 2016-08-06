//
//  GPATableViewController.swift
//  StudentSistant
//
//  Created by Andrew Jones on 4/22/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

class GPATableViewController: UITableViewController {

    var grades = [Grade]()
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.leftBarButtonItem = addButton
        navBar.rightBarButtonItem = editButtonItem
        
        if let savedGrades = loadGrades() {
            grades += savedGrades
        }
        
        setNavBarTitle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        isEditing = false
        if segue.identifier == "ShowDetail" {
            let gradeDetailViewController = segue.destination as! GradeViewController
            
            // Get the cell that generated this segue.
            if let selectedGradeCell = sender as? GradeTableViewCell {
                let indexPath = tableView.indexPath(for: selectedGradeCell)!
                let selectedGrade = grades[(indexPath as NSIndexPath).row]
                gradeDetailViewController.grade = selectedGrade
            }
        }
    }
    
    //Set one column of cells
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Allows editing of the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            grades.remove(at: (indexPath as NSIndexPath).row)
            saveGrades()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        setNavBarTitle() //Intuitively calculates GPA or sets default title when cells are deleted
    }
    
    //Set number of filled rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades.count
    }
   
    //Setup each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GradeTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GradeTableViewCell
        
        // Fetches the appropriate grade for the data source layout.
        let grade = grades[(indexPath as NSIndexPath).row]
        
        cell.courseName.text = grade.course! + ": " ?? ""
        switch grade.letter{
        case 1: cell.gradeReceived.text = "A  "
        case 2: cell.gradeReceived.text = "A-"
        case 3: cell.gradeReceived.text = "B+"
        case 4: cell.gradeReceived.text = "B  "
        case 5: cell.gradeReceived.text = "B-"
        case 6: cell.gradeReceived.text = "C+"
        case 7: cell.gradeReceived.text = "C  "
        case 8: cell.gradeReceived.text = "C-"
        case 9: cell.gradeReceived.text = "D+"
        case 10: cell.gradeReceived.text = "D  "
        case 11: cell.gradeReceived.text = "D-"
        case 12: cell.gradeReceived.text = "F  "
        default: cell.gradeReceived.text = "   "
        }
        
        switch grade.level{
        case 1: cell.levelLabel.text = "Standard"
        case 2: cell.levelLabel.text = "Honors"
        case 3: cell.levelLabel.text = "AP/IB"
        default: cell.levelLabel.text = ""
        }
        
        return cell
    }
    
    
    @IBAction func unwindToGradeList(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GradeViewController, let grade = sourceViewController.grade {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing grade.
                grades[(selectedIndexPath as NSIndexPath).row] = grade
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                // Add a new grade.
                let newIndexPath = IndexPath(row: grades.count, section: 0)
                grades.append(grade)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            setNavBarTitle() //Intuitively calculates GPA when cells are added
        }
        saveGrades()
    }
    
    //Helper method used to set title for navbar
    func setNavBarTitle() {
        if !grades.isEmpty{
            navBar.title = "\(calcGPA())"
        }else{
            navBar.title = "GPA Calculator"
        }
    }
    
    //Helper method to calculate the GPA from the grades array
    func calcGPA() -> Double {
        var sum = 0.0
        var counter = 0.0
        for grade in grades {
            counter += 1.0
            if grade.level == 1 {
                switch grade.letter{
                case 1: sum += 4.0
                case 2: sum += 3.66
                case 3: sum += 3.33
                case 4: sum += 3.00
                case 5: sum += 2.66
                case 6: sum += 2.33
                case 7: sum += 2.00
                case 8: sum += 1.66
                case 9: sum += 1.33
                case 10: sum += 1.00
                case 11: sum += 0.66
                case 12: sum += 0
                default: sum += 0
                }
            }
            else if grade.level == 2 {
                switch grade.letter{
                case 1: sum += 4.50
                case 2: sum += 4.16
                case 3: sum += 3.83
                case 4: sum += 3.50
                case 5: sum += 3.16
                case 6: sum += 2.83
                case 7: sum += 2.50
                case 8: sum += 2.16
                case 9: sum += 1.83
                case 10: sum += 1.50
                case 11: sum += 1.16
                case 12: sum += 0
                default: sum += 0
                }
            }
            else if grade.level == 3 {
                switch grade.letter{
                case 1: sum += 5.0
                case 2: sum += 4.66
                case 3: sum += 4.33
                case 4: sum += 4.00
                case 5: sum += 3.66
                case 6: sum += 3.33
                case 7: sum += 3.00
                case 8: sum += 2.66
                case 9: sum += 2.33
                case 10: sum += 2.00
                case 11: sum += 1.66
                case 12: sum += 0
                default: sum += 0
                }
            }
        }
        print("\(round((sum/counter) * 100)/100))")
        return round((sum/counter) * 100)/100
    }
    
    //MARK: NSCoding
    
    func saveGrades() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(grades, toFile: Grade.ArchiveURL.path) //saves array grades to file defined in Grade class
        
        if !isSuccessfulSave { //Diagnostic
            print("Save failed")
        }
    }
    
    func loadGrades() -> [Grade]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Grade.ArchiveURL.path) as? [Grade] //gets array grades from file where saved, defined in Grade class
        
    }
    
}
