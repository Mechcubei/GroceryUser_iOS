//
//  OrderDetailListVC.swift
//  GroceryUser
//
//  Created by osx on 05/01/21.
//  Copyright © 2021 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class OrderDetailListVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var OrderListTblView: UITableView!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblGst: UILabel!
    @IBOutlet var lblDeliveryCharges: UILabel!
    @IBOutlet var lblApplyCoupans: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblInProgress: UILabel!
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var viewUpperHidden: DesignableView!
    @IBOutlet var acceptHideButton: UIStackView!
    @IBOutlet var orderReadyButton: UIStackView!
    @IBOutlet var inProgressStack: UIStackView!
    @IBOutlet var tblViewHeight: NSLayoutConstraint!
    @IBOutlet var reasonTblView: UITableView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPhoneNo: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblCreatedAt: UILabel!
    @IBOutlet var lblOrderNo: UILabel!
    @IBOutlet var lblInProcssStatus: UILabel!
    
    //MARK:- LOCAL VARIABLES
    var orderId:Int?
    var arrUserOrderList = [UserOrderViewStruct2]()
    var status:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNibFileName()
        self.UserOrderView()
        
        
        
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.OrderListTblView.register(UINib(nibName: "OrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailTableViewCell")
    }
    
    //MARK:- MERCHANT ORDER VIEW
    func UserOrderView() {
        let params:[String:Any] = ["order_id":orderId!]
        Loader.shared.showLoader()
        GetApiResponse.shared.userOrderView(params: params) { (data:UserOrderViewStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            self.arrUserOrderList = data.data
            self.OrderListTblView.reloadData()
            self.view.layoutIfNeeded()
            self.tblViewHeight.constant = self.OrderListTblView.contentSize.height
            self.view.layoutIfNeeded()
            self.setUpUserData(amount: self.arrUserOrderList[0].sub_total!, gst: self.arrUserOrderList[0].gst!, deliveryCharges: self.arrUserOrderList[0].delivery_charge!, appliedCoupon: 0, totalAmount: self.arrUserOrderList[0].total!, deliveryAddress: self.arrUserOrderList[0].addressinfo[0].address ?? "", firstName: self.arrUserOrderList[0].userinfo[0].first_name!, lastName: self.arrUserOrderList[0].userinfo[0].last_name!, phoneNumber: self.arrUserOrderList[0].userinfo[0].phone!, statuss: data.data[0].status!, createdAt: data.data[0].created_at!, OrderNo: data.data[0].order_number!)
            
            self.status = self.arrUserOrderList[0].status!
            self.lblInProcssStatus.isHidden = self.status! == "in-process" ? false : true
        }
    }
    
    
    //MARK:- SETUP MERCHANT DATA
    func setUpUserData(amount:Double,gst:Double,deliveryCharges:Int,appliedCoupon:Int,totalAmount:Double,deliveryAddress:String,firstName:String,lastName:String,phoneNumber:Int,statuss:String,createdAt:String,OrderNo:String) {
        
        self.lblAmount.text = "\(amount)"
        self.lblGst.text = "\(gst)"
        self.lblDeliveryCharges.text = "\(deliveryCharges)"
        self.lblApplyCoupans.text = "\(appliedCoupon)"
        self.lblTotalAmount.text = "\(totalAmount)"
        self.lblAddress.text = deliveryAddress
        self.lblName.text = firstName + " " + lastName
        self.lblPhoneNo.text = "\(phoneNumber)"
        self.lblStatus.text = statuss
        self.lblCreatedAt.text = createdAt
        self.lblOrderNo.text = OrderNo
        self.lblInProcssStatus.startBlink()

    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- EXTENSION TABLE VIEW
@available(iOS 13.0, *)
extension OrderDetailListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell", for: indexPath) as! OrderDetailTableViewCell
        cell.lblProductName.text = arrUserOrderList[indexPath.row].merchants[0].merchant_items[indexPath.row].inventory_name!
        cell.lblQty.text = "\(arrUserOrderList[indexPath.row].merchants[0].merchant_items[indexPath.row].quantity!)"
        cell.lblPrice.text = "\(arrUserOrderList[indexPath.row].merchants[0].merchant_items[indexPath.row].price!)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
}
