//
//  Date.swift
//  CarFit
//
//  Created by Hitesh Khunt on 06/10/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

/*---------------------------------------------------
 Date Formatter
 ---------------------------------------------------*/
let _serverFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    df.locale = Locale(identifier: "en_US_POSIX")
    return df
}()

let _deviceFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = TimeZone.current
    df.dateFormat = "yyyy-MM-dd"
    return df
}()

extension Date {
    
    /// Used to return date from server format
    /// - Parameters:
    ///   - string: server date key
    ///   - format: format to convert
    /// - Returns: Returns date based on server
    static func dateFromServerFormat(from string: String, format: String = "yyyy-MM-dd'T'HH:mm:ss") -> Date?{
        _serverFormatter.dateFormat = format
        return _serverFormatter.date(from: string)
    }
    
    
    /// Converts to local date format
    /// - Parameters:
    ///   - date: Pass date to convert
    ///   - format: Convert to format, default added
    /// - Returns: Returns date as per local TimeZone
    static func localDateString(from date: Date?, format: String = "yyyy-MM-dd") -> String{
        _deviceFormatter.dateFormat = format
        if let _ = date{
            return _deviceFormatter.string(from: date!)
        }else{
            return ""
        }
    }
}

extension Date {
    
    /// Fetch date of specified month
    /// - Parameter counter: Value of the specified month to add or deduct.
    /// - Returns: This metho will return Date of specified month
    func getMonth(counter: Int) -> Date {
        let dt = Calendar.current.date(byAdding: .month, value: counter, to: self)!
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: dt))!
    }
    
    /// Used to get Start Date of Month
    /// - Returns: Returns Month Start Date
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    /// Used to get End Date of Month
    /// - Returns: Returns Month End Date
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    /// Fetch all dates between start to end date
    /// - Parameters:
    ///   - fromDate: date from we want to fetch date
    ///   - toDate: date to we want to fetch date
    /// - Returns: Returns Array of all dates between from and to date
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
}
