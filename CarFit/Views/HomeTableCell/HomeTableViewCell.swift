//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    func prepareCleanerListUI(data: CarWashVisit) {
        customer.text = data.ownerFullName
        status.text = data.visitState.rawValue
        statusView.backgroundColor = data.visitState.viewColor
        tasks.text = data.taskTitle
        arrivalTime.text = data.overAllTime
        destination.text = data.fullAddress
        timeRequired.text = data.totalTime
        distance.text = ""//String(format: "%.2f", data.houseLattitude)
    }
}
