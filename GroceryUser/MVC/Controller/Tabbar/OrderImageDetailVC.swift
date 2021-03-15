//
//  OrderImageDetailVC.swift
//  GroceryUser
//
//  Created by osx on 09/02/21.
//  Copyright © 2021 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class OrderImageDetailVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var detailCollectionView: UICollectionView!
    @IBOutlet var lblOrderNo: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPhoneNo: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblCreatedAt: UILabel!
    @IBOutlet var lblInprocessStatus: UILabel!
    @IBOutlet var collectnViewHeight: NSLayoutConstraint!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblInProgressStatus: UILabel!
    @IBOutlet var btnBill: DesignableButton!
    
    //MARK:- LOCAL VARIABLES
    var orderId:Int?
    var arrUserOrderList = [UserOrderViewStruct2]()
    var imagesArray = [OrderImage]()
    var status = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.UserOrderView()
        self.tabBarController?.tabBar.isHidden = true
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.UserOrderView()
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.detailCollectionView.register(UINib(nibName: "OrderImageDetailCell", bundle: nil), forCellWithReuseIdentifier: "OrderImageDetailCell")
    }
    //MARK:- MERCHANT ORDER VIEW
    func UserOrderView() {
        let params:[String:Any] = ["order_id":orderId!]
        Loader.shared.showLoader()
        GetApiResponse.shared.userOrderView(params: params) { (data:UserOrderViewStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            self.arrUserOrderList = data.data
            self.imagesArray =  self.arrUserOrderList[0].order_images!
            self.setUpUI(orderNo: data.data[0].order_number!, status: data.data[0].status!, createdAt: data.data[0].created_at!, name: data.data[0].userinfo[0].first_name!, phoneNo: data.data[0].userinfo[0].phone!, address: data.data[0].addressinfo[0].address!, lastName: data.data[0].userinfo[0].last_name!)
            self.status = self.arrUserOrderList[0].status!
            self.lblInProgressStatus.isHidden = self.status == "in-process" ? false : true
            self.btnBill.isHidden = self.status == "in-process" ? false : true
            self.detailCollectionView.reloadData()
            self.view.layoutIfNeeded()
            self.collectnViewHeight.constant = self.detailCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func setUpUI(orderNo:String,status:String,createdAt:String,name:String,phoneNo:Int,address:String,lastName:String) {
        
        self.lblOrderNo.text = orderNo
        self.lblStatus.text = status
        self.lblName.text = name + " " + lastName
        self.lblPhoneNo.text = "\(phoneNo)"
        self.lblCreatedAt.text = createdAt
        self.lblAddress.text = address
        self.lblInProgressStatus.startBlink()
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCreateBill(_ sender: Any) {
        let vc = ENUM_STORYBOARD<OrderDetailVC>.tabbar.instantiativeVC()
        vc.merchantUploadImage = arrUserOrderList[0].merchant_accept_image!
        vc.totalBill = arrUserOrderList[0].total_bill!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- EXTENTION COLLECTION VIEW
@available(iOS 13.0, *)
extension OrderImageDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderImageDetailCell", for: indexPath) as! OrderImageDetailCell
    
        let imgUrl = arrUserOrderList[0].order_images![indexPath.row].gro_image!
        cell.imgView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: detailCollectionView.frame.size.width/2, height: detailCollectionView.frame.size.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
