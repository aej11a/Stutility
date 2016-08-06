//
//  Assignment.swift
//  StudentSistant
//
//  Created by Andrew Jones on 6/9/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

class Assignment: NSObject, NSCoding {
    
    //MARK: Properties
    
    var hw: String?
    var date: String?
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("assignments")
    
    init?(hw: String?, date: String){
        self.hw = hw
        self.date = date
        super.init()
    }

    struct PropertyKey {
        static let hwKey = "hw"
        static let dateKey = "date"
    }
    
    func encode(with aCoder: NSCoder) {
     //Encodes each of the properties with the keys defined in struct PropertyKey
     aCoder.encode(hw, forKey: PropertyKey.hwKey)
     aCoder.encode(date, forKey: PropertyKey.dateKey)
     }
     
    required convenience init?(coder aDecoder: NSCoder) {
        //'required' means subclasses must implement, 'convenience' means it is a secondary constructor
        //Decodes each property and calls priamry constructor
        let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as? String
        let hw = aDecoder.decodeObject(forKey: PropertyKey.hwKey) as? String
     
     //Call designated (primary) initializer
        self.init(hw: hw, date: date!)
    }
    
}
