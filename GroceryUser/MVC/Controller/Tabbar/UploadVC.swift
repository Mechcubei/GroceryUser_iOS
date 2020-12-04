//
//  UploadVC.swift
//  GroceryUser
//
//  Created by osx on 22/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class UploadVC: UIViewController {
    
    //MARK:- LOCAL VARIABLES
    var categoryID:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func btnUpload(_ sender: Any) {
        let vc = ENUM_STORYBOARD<UploadPhotoVC>.tabbar.instantiativeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSelectList(_ sender: Any) {
        let vc = ENUM_STORYBOARD<SelectListVC>.tabbar.instantiativeVC()
        vc.categoriesID = categoryID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
