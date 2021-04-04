//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Hitesh Khunt on 10/10/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit
import CoreLocation

// MARK:- CleanerList View Model
class CleanerListViewModel {
    
    //MARK:- Final Values
    final var distanceInMiles =  0.000621371
    
    //MARK:- Variables
    var arrCarWashVisit: [CarWashVisit] = []
        
    
    /// User to find distance between washer and CarFir Clients
    /// - Parameters:
    ///   - fromLocation: location to start
    ///   - toLocation: location to end
    /// - Returns: It will return distance in miles
    func getDistanceFromWasher(fromLocation: CLLocation, toLocation: CLLocation) -> String? {
        var strDistanceInMiles: String?
        let distance = fromLocation.distance(from: toLocation) * distanceInMiles
        strDistanceInMiles = String(format: "%.2f", distance)
        return strDistanceInMiles
    }
    
    //MARK:- initializer will fill up visit details of selected dates
    init(dict: NSDictionary, date: String) {
        let datesContains = date.components(separatedBy: ",")
       
        if let washVisitListDict = dict["data"] as? [NSDictionary] {
           
            for cleanerListInfo in washVisitListDict {
                let objList = CarWashVisit(dict: cleanerListInfo)
                if datesContains.contains(objList.strStartTime) {
                    self.arrCarWashVisit.append(objList)
                }
            }
            
        }
    }
}

// MARK:- CarWashVisit Model
class CarWashVisit {
    
    // MARK:- Variables
    let visitId: String
    let ownerFirstName: String
    let ownerLastName: String
    let ownerAddress: String
    let ownerZipCode: String
    let ownerCity: String
    
    let houseLattitude: Double
    let houseLongitude: Double
    
    var startTime: Date?
    var expectedTime: Date?
  
    let visitState: EnumVisitState
    
    // MARK:- Enum For Visit Status
    enum EnumVisitState: String {
        case todo = "ToDo"
        case inProgress = "InProgress"
        case done = "Done"
        case rejected = "Rejected"
        
        var viewColor: UIColor {
            switch self {
            case .todo:
                return UIColor.todoOption
            case .inProgress:
                return UIColor.inProgressOption
            case .done:
                return UIColor.doneOption
            case .rejected:
                return UIColor.rejectedOption
            }
        }
    }
    
    // MARK:- Task List
    var arrTasks: [Tasks] = []
    
    // MARK:- Computed Properties
    var ownerFullName: String {
        return "\(ownerFirstName) \(ownerLastName)"
    }
    
    var location: CLLocation {
        return CLLocation(latitude: houseLattitude, longitude: houseLongitude)
    }
    
    var strStartTime: String {
        return Date.localDateString(from: startTime)
    }
    
    var overAllTime: String {
        let strStartTime = Date.localDateString(from: startTime, format: "HH:mm")
        let strExpectedTime = Date.localDateString(from: expectedTime, format: "HH:mm-HH:mm")
        return "\(strStartTime) / \(strExpectedTime)"
    }
    
    var fullAddress: String {
        return "\(ownerAddress) \(ownerZipCode) \(ownerCity)"
    }
    
    var totalTime: String {
        let total = arrTasks.map{$0.time}.reduce(0,+)
        return total.secondsToHoursMinutesSeconds()
    }
    
    var taskTitle: String {
        return arrTasks.map{$0.title}.joined(separator: " , ")
    }
    
    // MARK:- Fill CleanerListModel
    init(dict: NSDictionary) {
        visitId = dict.getStringValue(key: "visitId")
        ownerFirstName = dict.getStringValue(key: "houseOwnerFirstName")
        ownerLastName = dict.getStringValue(key: "houseOwnerLastName")
        ownerAddress = dict.getStringValue(key: "houseOwnerAddress")
        ownerZipCode = dict.getStringValue(key: "houseOwnerZip")
        ownerCity = dict.getStringValue(key: "houseOwnerCity")
        
        houseLattitude = dict.getDoubleValue(key: "houseOwnerLatitude")
        houseLongitude = dict.getDoubleValue(key: "houseOwnerLongitude")
        
        visitState = EnumVisitState(rawValue: dict.getStringValue(key: "visitState")) ?? .todo
        
        startTime = Date.dateFromServerFormat(from: dict.getStringValue(key: "startTimeUtc"))
        expectedTime = Date.dateFromServerFormat(from: dict.getStringValue(key: "expectedTime"), format: "HH:mm/HH:mm")

        if let arrTaskList = dict["tasks"] as? [NSDictionary] {
            arrTaskList.forEach { (dictData) in
                self.arrTasks.append(Tasks(dict: dictData))
            }
        }
    }
}
