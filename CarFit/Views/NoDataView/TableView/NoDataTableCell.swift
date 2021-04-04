//
//  NoDataTableCell.swift
//  Avatrac
//
//  Created by Hitesh Khunt on 10/04/19.
//  Copyright © 2019 Hitesh Khunt. All rights reserved.
//

import UIKit

class NoDataTableCell: UITableViewCell {

    @IBOutlet weak var lblNoData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setText(str: String) {
        lblNoData.text = str
    }
}
