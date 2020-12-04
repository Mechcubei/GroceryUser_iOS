//
//  OfferDetailVC.swift
//  GroceryUser
//
//  Created by osx on 30/09/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class OfferDetailVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var viewDismiss: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewHiddenOnTap()
 
    }
    func viewHiddenOnTap() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDimss(sender:)))
        viewDismiss.addGestureRecognizer(tap)
        
    }
    
    @objc func tapToDimss(sender:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}
