//
//  Other.swift
//  CarFit
//
//  Created by Hitesh Khunt on 06/10/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

extension Double {
    //MARK:- Convert Value to Hours & Minutes
    func secondsToHoursMinutesSeconds () -> String {
        let second = Int(self * 60)
        var displayString : String = ""
        if (second / 3600) >= 1 {
            displayString =  "\(displayString) \(second / 3600) h"
        }

        if ((second % 3600) / 60) > 0 {
            displayString = "\(displayString) \((second % 3600) / 60) m"
        }
      return displayString
    }
}



