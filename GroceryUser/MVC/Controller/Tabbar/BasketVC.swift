//
//  BasketVC.swift
//  GroceryUser
//
//  Created by osx on 22/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class BasketVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var btnCheckOut: DesignableButton!
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var lblTotalRupees: UILabel!
    @IBOutlet var lblSaveRupees: UILabel!
    @IBOutlet var btnBack: UIButton!
    
    //MARK:- LOCAL VARIABLES
    var arrSelectedList = [ListCategoryStruct2]()
    var myIndex = Int()
    var buyNow:Bool = false
    var totalAddToCart:Int = 0
    var totalSaveRupees:Int = 0
    var isCommingFromSelectList:Bool = false
    var totalPricee = Int()
    var buyNowTotalPrice = Int()
    var deliveryCharges = Int()
   
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.btnBack.isHidden = self.isCommingFromSelectList == true ? false : true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.registerNibFileName()
        guard !buyNow else {
            self.lblTotalRupees.text = "Rs.\(self.arrSelectedList[0].discount!)/-"
            self.lblSaveRupees.text = "Saved Rs.\(self.arrSelectedList[0].price! - self.arrSelectedList[0].discount!)/-"
            self.tabBarController?.tabBar.isHidden = true
            return
        }
        self.basketList()
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.tblView.register(UINib(nibName: "ReviewBasketTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewBasketTableViewCell")
    }
    
    //MARK:- BASKET LIST API
    func basketList() {
        let params:[String:Any] = ["":""]
        Loader.shared.showLoader()
        GetApiResponse.shared.basketList(params: params) { (data:ListCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            guard data.statusCode == 200 else{
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                self.viewNoDataFound.isHidden = false
                return
            }
            
            self.arrSelectedList = data.data!
            guard self.arrSelectedList.count >= 0 else{
                self.viewNoDataFound.isHidden = false
                return
            }
            
            self.viewNoDataFound.isHidden = true
            self.calculateAddToCartPrice()
            self.tblView.reloadData()
        }
    }
    //MARK:- ADDING OF BUY NOW TOTAL PRICE VALUES
    func calculateBuyNowPrice(quantity:Int){
        self.lblTotalRupees.text =  "Rs." + "\(self.arrSelectedList[0].discount! * quantity)/-"
        
    }
    
    func calculateByNowSavedPrice(quantity:Int) {
        self.lblSaveRupees.text = "Saved Rs.\(self.arrSelectedList[0].price! * quantity - self.arrSelectedList[0].discount! * quantity)/-"
    }
    
    
    //MARK:- ADDING OF ADD TO CART TOTAL PRICE VALUES
    func calculateAddToCartPrice() {

        self.lblTotalRupees.text = "Rs.\(String(describing: arrSelectedList[0].total_discount!))/-"
        self.lblSaveRupees.text = "Saved Rs\(String(describing: arrSelectedList[0].saved_price!))/-"
        self.totalPricee = arrSelectedList[0].total_discount!
        self.tblView.reloadData()
        
    }
    
    //MARK:- ADD TO BASKET API
    func addToBasket(index:Int) {
        
        let params:[String:Any] =
            [
                "merchant_user_id":arrSelectedList[index].marchent_user_id!,
                "merchant_inventory_id":arrSelectedList[index].merchant_inventory_id!,
                "quantity":arrSelectedList[index].quantity!
            ]
        print(params)
        GetApiResponse.shared.addToBasket(params: params) { (data:AddToBasketStruct) in
            print(data)
         
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            self.basketList()
        }
    }
    
    //MARK:- DELETE BASKET API
    func deleteBasketList(index:Int) {
        
        let params:[String:Any] = [
            "basket_id":arrSelectedList[index].basket_id!,
            "merchant_user_id":arrSelectedList[index].marchent_user_id!
        ]
        
        GetApiResponse.shared.deleteBasketList(params: params) { (data:AddToBasketStruct) in
            print(data)
            
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title:"ALERT!", msg: data.message!)
                return
            }
            self.arrSelectedList.remove(at: index)
            
            if self.arrSelectedList.count == 0 {
                self.viewNoDataFound.isHidden = false
            }
            Utilities.shared.showAlertWithOK(title:"SUCCESS", msg: data.message!)
            self.basketList()
            self.tblView.reloadData()
        }
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnCheckOut(_ sender: Any) {
        let vc = ENUM_STORYBOARD<DeliveryOptionVC>.tabbar.instantiativeVC()
        vc.arrProduct = arrSelectedList
        
        guard buyNow == false else {
            vc.price = Int(totalPricee)
            print(vc.price)
            vc.buyNow = buyNow
            vc.deliveryCharges = 60
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        vc.price = Int(totalPricee)
        print(vc.price)
        vc.deliveryCharges = deliveryCharges
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- MINUS BUTTON ACTION
    @objc func Minus(sender:UIButton) {
        
        if !buyNow == false {
            
            // when user comes from buy now
            print("Minus TAPPED")
            if self.arrSelectedList[sender.tag].selectedQty == nil {
                self.arrSelectedList[sender.tag].selectedQty = 1
            }
            guard self.arrSelectedList[sender.tag].selectedQty!  == 1 else {
                self.arrSelectedList[sender.tag].selectedQty! -= 1
                self.calculateBuyNowPrice(quantity:self.arrSelectedList[sender.tag].selectedQty!)
                self.calculateByNowSavedPrice(quantity: self.arrSelectedList[sender.tag].selectedQty!)
                self.tblView.reloadData()
                return
            }
            
            self.arrSelectedList.remove(at: sender.tag)
            self.navigationController?.popViewController(animated: true)
            self.tblView.reloadData()
            
        } else {
            
            // when user comes from add to cart
            guard self.arrSelectedList[sender.tag].quantity!  == 1 else {
                self.arrSelectedList[sender.tag].quantity! -= 1
                print("now count is", self.arrSelectedList[sender.tag].quantity!)
                self.calculateAddToCartPrice()
                self.addToBasket(index: sender.tag)
                self.tblView.reloadData()
                return
            }
        
            self.deleteBasketList(index: sender.tag)
            self.tblView.reloadData()
        }
    }
    //MARK:- PLUS BUTTON ACTION
    @objc func Plus(sender:UIButton) {
        
        // when user come from buynow button
        if !buyNow == false {
            
            if  self.arrSelectedList[sender.tag].selectedQty == nil {
                self.arrSelectedList[sender.tag].selectedQty = 1
            }
             self.arrSelectedList[sender.tag].selectedQty! += 1
            
            print("now count is", self.arrSelectedList[sender.tag].selectedQty!)
            if  self.arrSelectedList[sender.tag].selectedQty! == self.arrSelectedList[sender.tag].qty {
                Utilities.shared.showAlertWithOK(title: "", msg: "Out of Limit")
                return
            }
        
            self.calculateByNowSavedPrice(quantity: self.arrSelectedList[sender.tag].selectedQty!)
            self.calculateBuyNowPrice(quantity:self.arrSelectedList[sender.tag].selectedQty!)
            
            self.tblView.reloadData()
            
        } else {
            
            // when user added to bucket
            if  self.arrSelectedList[sender.tag].quantity! == self.arrSelectedList[sender.tag].qty {
                Utilities.shared.showAlertWithOK(title: "", msg: "Out of Limit")
                return
            }
            self.arrSelectedList[sender.tag].quantity! += 1
            print("now count is", self.arrSelectedList[sender.tag].quantity!)
            self.addToBasket(index: sender.tag)
            self.calculateAddToCartPrice()
            self.tblView.reloadData()
        }
    }
    
    @objc func buyNow(sender:UIButton) {
        let vc = ENUM_STORYBOARD<DeliveryOptionVC>.tabbar.instantiativeVC()
        vc.arrProduct = arrSelectedList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- PRODUCT DETAIL ACTION BUTTON
    @objc func btnProductdetailAction(sender:UIButton) {
        print("TAPPED")
        let vc = ENUM_STORYBOARD<ProductDetailVC>.tabbar.instantiativeVC()
        vc.merchantInventoryID = arrSelectedList[sender.tag].merchant_inventory_id!
        vc.arrProductDetail = arrSelectedList
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- EXTENSTION TABLEVIEW
@available(iOS 13.0, *)
extension BasketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewBasketTableViewCell", for: indexPath) as! ReviewBasketTableViewCell
        
        
        if !buyNow == false  {
            //when user come from ByNow Button
            cell.lblProductName.text = arrSelectedList[indexPath.row].inventory_name
            cell.lblValueIncrimentAndDecrement.text = "\(arrSelectedList[indexPath.row].selectedQty ?? 1)"
            
            cell.lblPrice.text = "\(String(describing: arrSelectedList[indexPath.row].price!))/-"
            cell.lblDiscount.text = "\(String(describing: arrSelectedList[indexPath.row].discount!))"
            cell.lblWeightType.text = arrSelectedList[indexPath.row].weight_type
            
            //MARK:- SET TAGS
            cell.btnPlus.tag = indexPath.row
            cell.btnMinus.tag = indexPath.row
            
            //MARK:- SET ACTIONS
            cell.btnPlus.addTarget(self, action: #selector(Plus(sender:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(Minus(sender:)), for: .touchUpInside)
            cell.btnProductDetail.addTarget(self, action: #selector(btnProductdetailAction(sender:)), for: .touchUpInside)
            
        } else {
            
            //When user come from AddToCart Button
            cell.btnBuyNow.isHidden = false
            cell.lblProductName.text = arrSelectedList[indexPath.row].inventory_name
            cell.lblValueIncrimentAndDecrement.text = "\(arrSelectedList[indexPath.row].quantity!)"
            cell.lblPrice.text = "Rs. \(String(describing: arrSelectedList[indexPath.row].price!))"
            cell.lblWeightType.text = arrSelectedList[indexPath.row].weight_type
            cell.lblDiscount.text = "\(String(describing: arrSelectedList[indexPath.row].discount!))/-"
            
            //MARK:- SET TAGS
            cell.btnPlus.tag = indexPath.row
            cell.btnMinus.tag = indexPath.row
            cell.btnBuyNow.tag = indexPath.row
            
            //MARK:- SET ACTIONS
            cell.btnPlus.addTarget(self, action: #selector(Plus(sender:)), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(Minus(sender:)), for: .touchUpInside)
            cell.btnBuyNow.addTarget(self, action: #selector(buyNow(sender:)), for: .touchUpInside)
            cell.btnProductDetail.addTarget(self, action: #selector(btnProductdetailAction(sender:)), for: .touchUpInside)
        
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
