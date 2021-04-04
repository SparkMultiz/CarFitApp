//
//  Tasks.swift
//  CarFit
//
//  Created by Hitesh Khunt on 10/10/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

class Tasks {
    
    let id: String
    let title: String
    let time: Double
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "taskId")
        title = dict.getStringValue(key: "title")
        time = dict.getDoubleValue(key: "timesInMinutes")
    }
}
