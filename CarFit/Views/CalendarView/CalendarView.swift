//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

//MARK:- Protocol to Pass Dates
protocol CalendarDelegate: class {
    func getMultipleSelectedDates(_ date: [CalendarDates])
}

class CalendarView: UIView {
    
    //MARK:- IB-Outlets

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    //MARK:- Variables
    private let cellID = "DayCell"
   
    weak var delegate: CalendarDelegate?
    weak var homeVC: HomeViewController?
    
    var monthCounter = 0
    
    var arrCalendarDates: [CalendarDates]!

    // MARK:- Computed Properties
    var getCurrentSelectedDate: Int {
        let todaysDate = Date.localDateString(from: Date(), format: "dd")
        let currentMonth = Date.localDateString(from: Date(), format: "MM")
        let currentYear = Date.localDateString(from: Date(), format: "yyyy")
        let calendarMonth = Date.localDateString(from: arrCalendarDates[0].date, format: "MM")
        let calendarYear = Date.localDateString(from: arrCalendarDates[0].date, format: "yyyy")
        let dateToSelect : Int = (currentMonth == calendarMonth && currentYear == calendarYear) ?  Int(todaysDate)! : 0
        return dateToSelect
    }
    
    var selectedDates: [CalendarDates] {
        return arrCalendarDates.filter{$0.isSelected}
    }
   
}

//MARK:- UI Methods
extension CalendarView {
    
    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        getSelectedMonthDates()
    }
    
    //MARK:- Fill Calendar With Selected Month
    func getSelectedMonthDates() {
        let getMonth = Date().getMonth(counter: monthCounter)
        let startOfMonth = getMonth.startOfMonth()
        let endOfMonth = getMonth.endOfMonth()
        let datesBetween = Date.dates(from: startOfMonth, to: endOfMonth)
        self.setCalendarDataSource(arrDates: datesBetween)
        self.monthAndYear.text = Date.localDateString(from: startOfMonth, format: "MMM yyyy")
    }
    
    //MARK:- CalendarView DataSource
    func setCalendarDataSource(arrDates: [Date]) {
        self.arrCalendarDates = []
        for dt in arrDates {
            let objCal = CalendarDates(date: dt)
            let strToday = Date.localDateString(from: Date())
            let strCalDate = Date.localDateString(from: objCal.date)
            objCal.isSelected = strToday == strCalDate
            self.arrCalendarDates.append(objCal)
        }
        self.daysCollectionView.reloadData()
        self.daysCollectionView.scrollToItem(at: IndexPath(row: getCurrentSelectedDate, section: 0), at: .centeredHorizontally, animated: true)
    }
}

//MARK:- UI Action
extension CalendarView {
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        if sender.tag == -1 {
            monthCounter -= 1
        } else {
            monthCounter += 1
        }
        homeVC?.selectedDate.removeAll()
        homeVC?.getClearnerList()
        self.getSelectedMonthDates()
    }

}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrCalendarDates == nil ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCalendarDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        cell.prepareCalendarUI(data: arrCalendarDates[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isSelected = arrCalendarDates[indexPath.row].isSelected
        arrCalendarDates[indexPath.row].isSelected = !isSelected
        delegate?.getMultipleSelectedDates(selectedDates)
        daysCollectionView.reloadData()
    }
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
}

