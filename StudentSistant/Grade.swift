//
//  Grade.swift
//  StudentSistant
//
//  Created by Andrew Jones on 4/22/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

import UIKit

class Grade: NSObject, NSCoding {

    // MARK: Properties

    var course: String?
    var letter: Int
    var level: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("grades")

    init?(course: String?, letter: Int, level: Int){
        self.course = course
        self.letter = letter
        self.level = level
        
        super.init()
    }

    struct PropertyKey {
        static let courseKey = "course"
        static let letterKey = "letter"
        static let levelKey = "level"
    }

    //MARK: NSCoding

    func encodeWithCoder(aCoder: NSCoder) {
        //Encodes each of the properties with the keys defined in struct PropertyKey
        aCoder.encodeObject(course, forKey: PropertyKey.courseKey)
        aCoder.encodeInteger(letter, forKey: PropertyKey.letterKey)
        aCoder.encodeInteger(level, forKey: PropertyKey.levelKey)
    }

    required convenience init?(coder aDecoder: NSCoder) { //'required' means subclasses must implement, 'convenience' means it is a secondary constructor
        //Decodes each property and calls priamry constructor
        let course = aDecoder.decodeObjectForKey(PropertyKey.courseKey) as? String
        let letter = aDecoder.decodeIntegerForKey(PropertyKey.letterKey)
        let level = aDecoder.decodeIntegerForKey(PropertyKey.levelKey)

        //Call designated (primary) initializer
        self.init(course: course, letter: letter, level: level)
    }
}
