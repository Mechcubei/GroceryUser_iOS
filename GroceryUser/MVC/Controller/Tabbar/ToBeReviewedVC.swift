//
//  ToBeReviewedVC.swift
//  GroceryUser
//
//  Created by osx on 29/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ToBeReviewedVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    
    //MARK:- LOCAL VARIABLES
    var arrUserOder = [datum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNibFileName()
        self.getUserOrder()
        
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")
    }
    
    func getUserOrder() {
        
        let params:[String:Any] = ["":""]
        GetApiResponse.shared.getUserOrder(params: params) { (data:GetUserOrderStruct) in
            print(data)
//            self.arrUserOder = data.data
//            self.tblView.reloadData()
            
        }
    }
}
//MARK:- EXTENTION TABLEVIEW
@available(iOS 13.0, *)
extension ToBeReviewedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserOder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrderTableViewCell
    //    cell.lblItems.text = "\(String(describing: arrUserOder[indexPath.row].quantity!)) Items"
      //  cell.lblDate.text = arrUserOder[indexPath.row].created_at
    //    cell.lblStatus.text = arrUserOder[indexPath.row].status
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
