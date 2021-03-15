//
//  ReviewedVC.swift
//  GroceryUser
//
//  Created by osx on 29/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ReviewedVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var lblAboutData: UILabel!
    
    //MARK:-LOCAL VARIABLES
    var arrUserOrder = [UserOrderStruct2]()
    var selectedIndex = 0
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.selectOrder(index: self.selectedIndex)
        self.pullToRefresh()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        self.selectOrder(index: self.selectedIndex)
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(callApi(notification:)), name: NSNotification.Name(rawValue: "orderType"), object:nil)
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "UserOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "UserOrderTableViewCell")
    }
    
    //MARK:- GET USER ORDER
    func getUserOder(status:String) {
        let params:[String:Any] = ["status":status]
        Loader.shared.showLoader()
        GetApiResponse.shared.getUserOrder(params: params) { (data:UserOrderStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            self.arrUserOrder = data.data
            self.viewNoDataFound.isHidden = self.arrUserOrder.count == 0 ? false : true
            self.lblAboutData.text = self.arrUserOrder.count == 0 ? data.message! : ""
            self.tblView.reloadData()
        }
    }
    
    //MARK:- REFRESH TABLEVIEW
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.darkGray
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tblView.addSubview(refreshControl!)
    }
    
    @objc func refresh() {
        self.selectOrder(index: self.selectedIndex)
        refreshControl?.endRefreshing()
        tblView.reloadData()
    }
    
    func selectOrder(index:Int) {
        self.arrUserOrder.removeAll()
        self.selectedIndex = index
        
        switch index {
            
        case 0:
            self.getUserOder(status: "all")
            
        case 1:
            self.getUserOder(status: "pending")
            
        case 2:
            self.getUserOder(status: "in-process")
            
        case 3:
            self.getUserOder(status: "ongoing")
            
        default:
            ""
        }
        self.tblView.reloadData()
    }
    
    @objc func  callApi(notification:Notification){
        let type = notification.userInfo!["type"] as! Int
        self.selectOrder(index: type)
    }
}

@available(iOS 13.0, *)
extension ReviewedVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOrderTableViewCell", for: indexPath) as! UserOrderTableViewCell
        cell.lblOrderId.text = "Order ID: \(String(describing: arrUserOrder[indexPath.row].id!))"
        cell.lblOrderNo.text = arrUserOrder[indexPath.row].order_number
        cell.lblTotal.text = "₹\(String(describing: arrUserOrder[indexPath.row].total!))"
        cell.lblCreatedAt.text = arrUserOrder[indexPath.row].created_at
        cell.lblPending.text = arrUserOrder[indexPath.row].payment_type
        
        switch arrUserOrder[indexPath.row].status {
        case "complete":
            cell.imgStatus.image = UIImage(named: "complate")
            
        case "cancel":
            cell.imgStatus.image = UIImage(named: "cancel")
            
        case "in-process":
            cell.imgStatus.image = UIImage(named: "in-process")
            
        case "accepted":
            cell.imgStatus.image = UIImage(named: "accepted")
            
        case "pending":
            cell.imgStatus.image = UIImage(named: "pending")
            
        default:
            ""
        }
        
        cell.lblStatus.text = arrUserOrder[indexPath.row].status
        cell.imgPro.cornerRadius = cell.imgPro.frame.size.width/2
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard arrUserOrder[indexPath.row].order_type == "grocery_image" else {
            let vc = ENUM_STORYBOARD<OrderDetailListVC>.tabbar.instantiativeVC()
            vc.orderId = arrUserOrder[indexPath.row].id!
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let vc = ENUM_STORYBOARD<OrderImageDetailVC>.tabbar.instantiativeVC()
        vc.orderId = arrUserOrder[indexPath.row].id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
