//
//  ParentViewController.swift
//  CarFit
//
//  Created by Hitesh Khunt on 06/10/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    //MARK:- Variables
    var actInd : UIActivityIndicatorView!
    var blurEffectView = UIView()

    // MARK: - Variables for Pull to Referesh
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

//MARK:- UI Methods
extension ParentViewController {
    
    //MARK:- UI setups
    func prepareUI() {
        actInd = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        actInd.center = view.center
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK:- Show Indicator
    func showHud() {
        blurEffectView.frame = .init(x: 0, y: 0, width: 80, height: 80)
        blurEffectView.center = view.center
        blurEffectView.backgroundColor = UIColor(white:0, alpha:0.6)
        blurEffectView.layer.cornerRadius = 5
        self.blurEffectView.alpha = 1
        view.addSubview(blurEffectView)
        
        blurEffectView.addSubview(actInd)
        actInd.frame.origin = CGPoint(x:(blurEffectView.frame.width / 2) - (actInd.frame.width / 2) , y: (blurEffectView.frame.height / 2) - (actInd.frame.height / 2))
        actInd.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    //MARK:- Hide Indicator
    func hideHud() {
        DispatchQueue.main.async {
            UIView.animate(withDuration:0.2, animations: {
                self.blurEffectView.alpha = 0
            }, completion: { (done) in
                self.actInd.stopAnimating()
                self.blurEffectView.removeFromSuperview()
            })
            self.view.isUserInteractionEnabled = true
        }
    }
}
