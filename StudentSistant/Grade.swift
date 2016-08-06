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
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("grades")

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

    func encode(with aCoder: NSCoder) {
        //Encodes each of the properties with the keys defined in struct PropertyKey
        aCoder.encode(course, forKey: PropertyKey.courseKey)
        aCoder.encode(letter, forKey: PropertyKey.letterKey)
        aCoder.encode(level, forKey: PropertyKey.levelKey)
    }

    required convenience init?(coder aDecoder: NSCoder) { //'required' means subclasses must implement, 'convenience' means it is a secondary constructor
        //Decodes each property and calls priamry constructor
        let course = aDecoder.decodeObject(forKey: PropertyKey.courseKey) as? String
        let letter = aDecoder.decodeInteger(forKey: PropertyKey.letterKey)
        let level = aDecoder.decodeInteger(forKey: PropertyKey.levelKey)

        //Call designated (primary) initializer
        self.init(course: course, letter: letter, level: level)
    }
}
