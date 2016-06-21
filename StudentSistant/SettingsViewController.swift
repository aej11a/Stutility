//
//  SettingsViewController.swift
//  StudentSistant
//
//  Created by Andrew Jones on 6/17/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController{
    
    //MARK: Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weekendSwitch: UISwitch!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    var sEdit = false
    var eEdit = false
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let weekendURL = DocumentsDirectory.URLByAppendingPathComponent("weekend")
    static let datesURL = DocumentsDirectory.URLByAppendingPathComponent("dates")
    var c = NSDateComponents()
    var dates = [NSDate]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.hidden = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/YY"
        
        if let prevDates = NSKeyedUnarchiver.unarchiveObjectWithFile(SettingsViewController.datesURL.path!) as? [NSDate] {
            dates = prevDates
            startLabel.text = dateFormatter.stringFromDate(dates[0])
            endLabel.text = dateFormatter.stringFromDate(dates[1])
        }else{
            dates.append(NSDate())
            c.year = 2016
            c.day = 24
            c.month = 6
            dates.append((NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(c))!)
            startLabel.text = dateFormatter.stringFromDate(NSDate())
            endLabel.text = dateFormatter.stringFromDate((NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(c))!)
        }
        
        if let on = NSKeyedUnarchiver.unarchiveObjectWithFile(SettingsViewController.weekendURL.path!) as? Bool {
            weekendSwitch.on = on
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //Set two sections of cells
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    //Set # rows based on which section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return 2
        case 1: return 1
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            switch(indexPath.row)
            {
            case 0:
                if sEdit {
                    sEdit = false
                    datePicker.hidden = true
                    saveDates()
                }else if !sEdit {
                    sEdit = true
                    eEdit = false
                    datePicker.hidden = false
                    datePicker.setDate(dates[0], animated: true)
                }
            case 1:
                if eEdit {
                    eEdit = false
                    datePicker.hidden = true
                    saveDates()
                }else if !eEdit {
                    eEdit = true
                    sEdit = false
                    datePicker.hidden = false
                    datePicker.setDate(dates[1], animated: true)
                }
            case 2:
                break;
            default:
                break;
            }
        }
    }
    
    //MARK: Picker View
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/YY"
        let convertedDate = dateFormatter.stringFromDate(datePicker.date)
        
        if sEdit {
            startLabel.text = convertedDate
            dates[0] = datePicker.date
        }else if eEdit {
            endLabel.text = convertedDate
            dates[1] = datePicker.date
        }
        
        saveDates()
    }
    
    //MARK: NSCoding
    
    func saveDates() {
        NSKeyedArchiver.archiveRootObject(dates, toFile: SettingsViewController.datesURL.path!)
    }
    @IBAction func weekendSwitch(sender: UISwitch) {
        NSKeyedArchiver.archiveRootObject(weekendSwitch.on, toFile: SettingsViewController.weekendURL.path!)
    }

}