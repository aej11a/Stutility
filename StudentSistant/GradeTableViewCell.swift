//
//  GradeTableViewCell.swift
//  StudentSistant
//
//  Created by Andrew Jones on 4/21/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

class GradeTableViewCell: UITableViewCell {
    
    //MARK: Properties
   
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var gradeReceived: UILabel!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
 
}
