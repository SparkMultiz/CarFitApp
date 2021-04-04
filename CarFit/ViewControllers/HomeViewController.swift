//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeViewController: ParentViewController, AlertDisplayer {
    
    //MARK:- IB-Outlets
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    //MARK:- IB-Outlets - To Manage Animation
    @IBOutlet weak var calConst: NSLayoutConstraint!
    @IBOutlet weak var tblTopConst: NSLayoutConstraint!
    
    //MARK:- Enum to Track CalendarView State
    var viewState: EnumViewState = .close
    
    enum EnumViewState {
        case close
        case open
    }
    
    //MARK:- Variables
    private var lastContentOffset: CGFloat = 0
    private let cellID = "HomeTableViewCell"
    
    var objCarVisit: CleanerListViewModel!
    var userLocation: CLLocation?
    var selectedDate : String = Date.localDateString(from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getWasherLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }
}
 
//MARK:- UI Methods
extension HomeViewController {

    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.homeVC = self
            calendar.delegate = self
        }
    }
    
    //MARK:- Add Empty View to TableView
    private func addNoDataCell() {
        workOrderTableView.register(UINib(nibName: "NoDataTableCell", bundle: nil), forCellReuseIdentifier: "noDataCell")
    }
    
    //MARK:- Returns Washer's Current Location
    private func getWasherLocation() {
        weak var controller: UIViewController! = self
        UserLocation.sharedInstance.fetchUserLocationForOnce(controller: controller) { (location, error) in
            self.userLocation = location
            self.getClearnerList()
        }
    }
    
    //MARK:- UI setups
    private func setupUI() {
        self.navigationTitle.title = self.selectedDate
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        self.workOrderTableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 10, right: 0)
        self.workOrderTableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.addNoDataCell()

    }
    
    //MARK:- Refresh Function
    @objc func refreshData() {
        self.getClearnerList()
    }
    
    //MARK:- Manage Calendar Animation
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewState == .open else {return}
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlDown, animations: {
                self.calConst.constant = 0
                self.tblTopConst.constant = 0
                self.view.layoutIfNeeded()
            }) { (completion) in
                self.viewState = .close
            }
        }
    }
}

//MARK:- UI Actions
extension HomeViewController {
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlDown, animations: {
            self.calConst.constant = 200.0
            self.tblTopConst.constant = 112.0
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.viewState = .open
        }
    }
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objCarVisit == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objCarVisit.arrCarWashVisit.isEmpty ? 1 : objCarVisit.arrCarWashVisit.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objCarVisit.arrCarWashVisit.isEmpty ? tableView.frame.size.height : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if objCarVisit.arrCarWashVisit.isEmpty {
            let cell: NoDataTableCell
            cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell", for: indexPath) as! NoDataTableCell
            cell.setText(str: "No Car Visit Today ...")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let carVisitCell = cell as? HomeTableViewCell {
            let objCarWash = objCarVisit.arrCarWashVisit[indexPath.row]
            carVisitCell.prepareCleanerListUI(data: objCarWash)
            carVisitCell.distance.text = objCarVisit.getDistanceFromWasher(fromLocation: userLocation!, toLocation: objCarWash.location)
        }
    }
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    
    func getMultipleSelectedDates(_ date: [CalendarDates]) {
        self.selectedDate = date.map{Date.localDateString(from: $0.date)}.filter{!$0.isEmpty}.joined(separator: ",")
        self.navigationTitle.title = self.selectedDate
        self.getClearnerList()
    }
}

//MARK:- Get CarWash List
extension HomeViewController {
    
     func getClearnerList() {
        if !refreshControl.isRefreshing {
            showHud()
        }
        guard let listPath = Bundle.main.path(forResource: "carfit", ofType: "json") else {return}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: listPath))
            if let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                self.objCarVisit = CleanerListViewModel(dict: dict, date: selectedDate)
            }
            self.hideHud()
            self.refreshControl.endRefreshing()
            self.workOrderTableView.reloadData()
        } catch let error as NSError {
            self.displayAlert(with: "Error:", message: error.localizedDescription)
        }
    }
}

