//
//  Header.h
//  StudentSistant
//
//  Created by Andrew Jones on 6/17/16.
//  Copyright © 2016 Andrew Jones. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */

//MARK: Date Comparisons
func <= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
func >= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}