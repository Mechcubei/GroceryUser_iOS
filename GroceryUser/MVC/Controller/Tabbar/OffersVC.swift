//
//  OffersVC.swift
//  GroceryUser
//
//  Created by osx on 29/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class OffersVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()

    }

    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.tblView.register(UINib(nibName: "OfferTableViewCell", bundle: nil), forCellReuseIdentifier: "OfferTableViewCell")
    }
    
}
//MARK:- EXTENTION TABLEVIEW
extension OffersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell", for: indexPath) as! OfferTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ENUM_STORYBOARD<OfferDetailVC>.tabbar.instantiativeVC()
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}
