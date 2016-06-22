//
//  GradeViewController.swift
//  StudentSistant
//
//  Created by Andrew Jones on 4/21/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

class GradeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var done: UIBarButtonItem!
    var grade: Grade?
    
    var grades = [["Level...", "Standard", "Honors", "AP"],["Grade...", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]]
    var letter = 0
    var level = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        if let grade = grade {
            textField.text = grade.course
            pickerView.selectRow(grade.letter, inComponent: 1, animated: true)
            pickerView.selectRow(grade.level, inComponent: 0, animated: true)
            letter = grade.letter
            level = grade.level
        }
        checkValidGrade()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func checkValidGrade() {
        if grades[0][level] == "Level..." || grades[1][letter] == "Grade..."
        {done.enabled = false}
        else {done.enabled = true}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            level = row
        }else if component == 1 {
            letter = row
        }
        checkValidGrade()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //Set # of rows in pickerView = to # elements in array
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return grades[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(grades[component][row])"
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if done === sender{
            let course = textField.text ?? ""
            // Set the grade to be passed to the table
            grade = Grade(course: course, letter: letter, level: level)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddGradeMode = presentingViewController is UINavigationController
        
        if isPresentingInAddGradeMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}