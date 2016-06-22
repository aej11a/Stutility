//
//  DailyHWViewController.swift
//  StudentSistant
//
//  Created by Andrew Jones on 6/7/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

class DailyHWViewController: UIViewController, UITextViewDelegate {

    //MARK: Properties
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var done: UIBarButtonItem!
    var assignment: Assignment!
    
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        textField.text = assignment.hw
        navBar.title = assignment.date
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if done === sender{
            let hw = textField.text ?? ""
            let date = assignment.date
            // Set the grade to be passed to the table
            assignment = Assignment(hw: hw, date: date!)!
        }
    }
    
}
