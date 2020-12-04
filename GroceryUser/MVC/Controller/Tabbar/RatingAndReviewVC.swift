//
//  RatingAndReviewVC.swift
//  GroceryUser
//
//  Created by osx on 29/09/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class RatingAndReviewVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNibFileName()
        self.fixedTableviewHeight()
 
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.tblView.register(UINib(nibName: "RatingAndreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingAndreviewTableViewCell")
    }
    
    func fixedTableviewHeight() {
        self.view.layoutIfNeeded()
        self.tblViewHeight.constant = self.tblView.contentSize.height
        self.view.layoutIfNeeded()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- EXTENTION TABLEVIEW
extension RatingAndReviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingAndreviewTableViewCell", for: indexPath) as! RatingAndreviewTableViewCell
        return cell
    }
}
