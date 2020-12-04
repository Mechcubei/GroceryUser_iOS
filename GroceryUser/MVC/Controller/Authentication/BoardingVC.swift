//
//  BoardingVC.swift
//  GroceryUser
//
//  Created by osx on 21/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class BoardingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    //MARK:- ACTION BUTTONS
    
    @IBAction func btnzlogin(_ sender: Any) {
        let vc = ENUM_STORYBOARD<LoginVC>.login.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = ENUM_STORYBOARD<SignUpVC>.login.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
