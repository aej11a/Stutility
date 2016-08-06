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
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let weekendURL = DocumentsDirectory.appendingPathComponent("weekend")
    static let datesURL = DocumentsDirectory.appendingPathComponent("dates")
    var c = DateComponents()
    var dates = [Date]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/YY"
        
        if let prevDates = NSKeyedUnarchiver.unarchiveObject(withFile: SettingsViewController.datesURL.path) as? [Date] {
            dates = prevDates
            startLabel.text = dateFormatter.string(from: dates[0])
            endLabel.text = dateFormatter.string(from: dates[1])
        }else{
            dates.append(Date())
            c.year = 2017
            c.day = 24
            c.month = 6
            dates.append((Calendar(identifier: Calendar.Identifier.gregorian).date(from: c))!)
            startLabel.text = dateFormatter.string(from: Date())
            endLabel.text = dateFormatter.string(from: (Calendar(identifier: Calendar.Identifier.gregorian).date(from: c))!)
        }
        
        if let on = NSKeyedUnarchiver.unarchiveObject(withFile: SettingsViewController.weekendURL.path) as? Bool {
            weekendSwitch.isOn = on
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //Set two sections of cells
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    //Set # rows based on which section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return 2
        case 1: return 1
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            switch((indexPath as NSIndexPath).row)
            {
            case 0:
                if sEdit {
                    sEdit = false
                    datePicker.isHidden = true
                    saveDates()
                }else if !sEdit {
                    sEdit = true
                    eEdit = false
                    datePicker.isHidden = false
                    datePicker.setDate(dates[0], animated: true)
                }
            case 1:
                if eEdit {
                    eEdit = false
                    datePicker.isHidden = true
                    saveDates()
                }else if !eEdit {
                    eEdit = true
                    sEdit = false
                    datePicker.isHidden = false
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
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/YY"
        let convertedDate = dateFormatter.string(from: datePicker.date)
        
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
        NSKeyedArchiver.archiveRootObject(dates, toFile: SettingsViewController.datesURL.path)
    }
    @IBAction func weekendSwitch(_ sender: UISwitch) {
        NSKeyedArchiver.archiveRootObject(weekendSwitch.isOn, toFile: SettingsViewController.weekendURL.path)
    }

}
