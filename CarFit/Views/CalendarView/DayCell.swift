//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
    
    /// It will prepare Calendar UI
    /// - Parameter data: Calendar Selected Date
    func prepareCalendarUI(data: CalendarDates) {
        day.text = Date.localDateString(from: data.date, format: "dd")
        weekday.text = Date.localDateString(from: data.date, format: "E")
        dayView.backgroundColor = data.isSelected ? UIColor.daySelected : UIColor.clear
    }
}
