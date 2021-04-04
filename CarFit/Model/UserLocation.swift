//
//  UserLocation.swift
//  CarFit
//
//  Created by Hitesh Khunt on 10/10/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationPermission: Int {
    case Accepted
    case Denied
    case Error
}

class UserLocation: NSObject {
    
    // MARK: - Variables
    var locationManger: CLLocationManager = {
        let lm = CLLocationManager()
        lm.activityType = .other
        lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()
    
    // Will be assigned by host controller. If not set can throw Exception.
    typealias LocationBlock = (CLLocation?, NSError?)->()
    var completionBlock : LocationBlock? = nil
    weak var controller: UIViewController!
    
    // MARK: - Init
    static let sharedInstance = UserLocation()
    
    
    /// This function will retutn User Last Updates Location
    /// - Parameters:
    ///   - controller: It will return updated location to controller
    ///   - block: Block to handle the callback
    func fetchUserLocationForOnce(controller: UIViewController, block: LocationBlock?) {
        self.controller = controller
        locationManger.delegate = self
        completionBlock = block
        if checkAuthorizationStatus() {
            locationManger.startUpdatingLocation()
        }
    }
    
    /// Pop-up for user location
    /// - Returns: If user allows for permission it will return it else navigate to setting
    func checkAuthorizationStatus() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        // If status is denied or only granted for when in use
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let title = "Location services are off"
            let msg = "To use location you must turn on 'WhenInUse' in the location services settings"
            
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            
            let cancel = UIAlertAction(title: "Cancle", style: UIAlertAction.Style.cancel, handler: nil)
            let settings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (action) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            })
            
            alert.addAction(cancel)
            alert.addAction(settings)
            controller.present(alert, animated: true, completion: nil)
            return false
        } else if status == CLAuthorizationStatus.notDetermined {
            locationManger.requestWhenInUseAuthorization()
            return false
        } else if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            return true
        }
        return false
    }
}

// MARK: - Location manager Delegation
extension UserLocation: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        DispatchQueue.main.async {
            self.completionBlock?(lastLocation,nil)
            self.locationManger.delegate = nil
            self.completionBlock = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManger.delegate = nil
        DispatchQueue.main.async {
            self.completionBlock?(nil,error as NSError?)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if checkAuthorizationStatus() {
            locationManger.startUpdatingLocation()
        }
    }
}

