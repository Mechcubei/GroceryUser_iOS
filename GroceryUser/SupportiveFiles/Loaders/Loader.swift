//
//  Loader.swift
//  Learning
//
//  Created by Amandeep tirhima on 2020-05-06.
//  Copyright © 2020 Amandeep tirhima. All rights reserved.



import UIKit
import Foundation
import NVActivityIndicatorView
class Loader: NSObject , NVActivityIndicatorViewable  {
    static let shared = Loader()
    
    override init() {
        super.init()
    }

    func showLoader() {
        let activityData = ActivityData(size: CGSize.init(width: 24, height: 24), message: nil, messageFont: UIFont(name: "Nexa-Bold", size: 14), type: .circleStrokeSpin, color: UIColor.black, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
   func stopLoader(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}
