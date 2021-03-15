//
//  SelectListVC.swift
//  GroceryUser
//
//  Created by osx on 27/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import SDWebImage

@available(iOS 13.0, *)
class SelectListVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var txtSearchField: UITextField!
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var btnFilter: UIButton!
    
    //MARK:- LOCAL VARIABLES
    var arrOderListCategoryWise = [ListCategoryStruct2]()
    var categoriesID:Int?
    var merchantUserID:Int?
    var merchantInventoryIDSelected:Int?
    var searchActive : Bool = false
    var addValue:String?
    var merchantInventoryID:Int?
    var isCommingFrom = 1
    var deliveryCharges:Int? = 60
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.catinventoryList()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.catinventoryList()
    }
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.tblView.register(UINib(nibName: "SelectListTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectListTableViewCell")
    }
    
    //MARK:- CATEGORY INVENTORY LIST API
    func catinventoryList() {
        
        let params:[String:Any] = [
            
            "category_id":categoriesID!,
            "marchent_user_id":merchantUserID!
        ]
        
        Loader.shared.showLoader()
        GetApiResponse.shared.catInventoryList(params: params) { (data:ListCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            guard data.statusCode == 200 else {
                self.viewNoDataFound.isHidden = false
                self.btnFilter.isUserInteractionEnabled = false
                self.btnFilter.backgroundColor = ENUMCOLOUR.ButtonUserInteractionColorDisable.getColour()
                return
            }
            self.arrOderListCategoryWise = data.data!
            //show  item detail which is already in basket
            self.setBascketSelectedItems(array: self.arrOderListCategoryWise.count)
            self.lblProductName.text = self.arrOderListCategoryWise[0].category_name
            self.txtSearchField.placeholder = "Total \(String(describing: self.arrOderListCategoryWise[0].total_items!)) Products"
            self.tblView.reloadData()
        }
    }
    
    func setBascketSelectedItems(array:Int){
        for i in 0..<array {
            if let _ = self.arrOderListCategoryWise[i].basket_qty{
                self.arrOderListCategoryWise[i].isSelected  =  true
                self.arrOderListCategoryWise[i].selectedQty = self.arrOderListCategoryWise[i].basket_qty
            }
        }
    }
        
    //MARK:- ADD TO BASKET API
    func addToBasket(index:Int) {
        
        let params:[String:Any] = [
            "merchant_user_id":arrOderListCategoryWise[index].marchent_user_id!,
            "merchant_inventory_id":arrOderListCategoryWise[index].merchant_inventory_id!,
            "quantity":arrOderListCategoryWise[index].selectedQty ?? 1
        ]
        print(params)
        GetApiResponse.shared.addToBasket(params: params) { (data:AddToBasketStruct) in
            print(data)
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            self.catinventoryList()
        }
    }
    
    //MARK:- DELETE BASKET API
    func deleteBasketList(index:Int) {
        
        let params:[String:Any] = [
            "basket_id":arrOderListCategoryWise[index].basket_id!,
            "merchant_user_id":merchantUserID!
        ]
        
        GetApiResponse.shared.deleteBasketList(params: params) { (data:ListCategoryStruct) in
            print(data)

            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            self.arrOderListCategoryWise[index].isSelected = false
            self.tblView.reloadData()
        }
    }
    
    //MARK:- ACTION BUTTONS
    @IBAction func btnSearch(_ sender: Any) {
    }
    
    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        
        let vc = ENUM_STORYBOARD<FilterVC>.tabbar.instantiativeVC()
        vc.delegateFilter = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:- ACTION ADD TO CART VALUE
    @objc func add(sender:UIButton){
        
        self.addToBasket(index: sender.tag)
        
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == nil {
            self.arrOderListCategoryWise[sender.tag].selectedQty = 1
        }
        
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == self.arrOderListCategoryWise[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "Stock out of Limit")
            return
        }
        
        self.arrOderListCategoryWise[sender.tag].isSelected = true
        self.tblView.reloadData()
        
    }
    
    //MARK:- ACTION PLUS VALUE
    @objc func plus(sender:UIButton){
        
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == nil {
            self.arrOderListCategoryWise[sender.tag].selectedQty = 0
        }
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == self.arrOderListCategoryWise[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "", msg: "Out of Limit")
            return
        }
        
        self.arrOderListCategoryWise[sender.tag].selectedQty! += 1
        
        print("now count is", self.arrOderListCategoryWise[sender.tag].selectedQty!)
        self.addToBasket(index: sender.tag)
        self.tblView.reloadData()
    }
    
    //MARK:- ACTION MINUS VALUE
    @objc func minus(sender:UIButton){
        
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == nil{
            self.arrOderListCategoryWise[sender.tag].selectedQty = 0
        }
        
        guard self.arrOderListCategoryWise[sender.tag].selectedQty!  > 0 else {
            print("now count is", self.arrOderListCategoryWise[sender.tag].selectedQty!)
            self.deleteBasketList(index: sender.tag)
            //self.addToBasket(index: sender.tag)
            //self.arrOderListCategoryWise[sender.tag].isSelected = false
            self.tblView.reloadData()
            return
        }
        
        self.arrOderListCategoryWise[sender.tag].selectedQty! -= 1
        print("now count is", self.arrOderListCategoryWise[sender.tag].selectedQty!)
        self.addToBasket(index: sender.tag)
        self.tblView.reloadData()
    }
    
    //MARK:- PRODUCT DETAIL ACTION BUTTON
    @objc func btnProductdetailAction(sender:UIButton) {
        
        if let _ = arrOderListCategoryWise[sender.tag].basket_qty {
            moveToDetail(BasketQ:arrOderListCategoryWise[sender.tag].basket_qty!, MId: self.arrOderListCategoryWise[sender.tag].merchant_inventory_id!)
        } else {
            moveToDetail(BasketQ:0, MId: self.arrOderListCategoryWise[sender.tag].merchant_inventory_id!)
        }
    }
    
    func moveToDetail(BasketQ:Int,MId:Int){
        let vc = ENUM_STORYBOARD<ProductDetailVC>.tabbar.instantiativeVC()
        vc.merchantInventoryID = MId
        vc.isCommingFrom = true
        vc.basketQuantity = BasketQ
        self.navigationController?.pushViewController(vc, animated: true)
    }
     
    //MARK:- BUY NOW BUTTON ACTION
    @objc func btnBuyNow(sender:UIButton) {
        let vc = ENUM_STORYBOARD<BasketVC>.tabbar.instantiativeVC()
        vc.arrSelectedList = [arrOderListCategoryWise[sender.tag]]
        vc.buyNow =  true
        vc.deliveryCharges = deliveryCharges!
        vc.isCommingFromSelectList = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddToBasket(_ sender: Any) {
        let vc = ENUM_STORYBOARD<BasketVC>.tabbar.instantiativeVC()
        vc.isCommingFromSelectList = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- EXTENSTION TABLEVIEW
@available(iOS 13.0, *)
extension SelectListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOderListCategoryWise.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectListTableViewCell", for: indexPath) as! SelectListTableViewCell
        
        // set data
        cell.lblProductInventoryName.text = arrOderListCategoryWise[indexPath.row].inventory_name
        cell.lblProductName.text = arrOderListCategoryWise[indexPath.row].category_name
        cell.lblPrice.text = "\(arrOderListCategoryWise[indexPath.row].price!)"
        cell.lblWeight.text = "Weight: " + arrOderListCategoryWise[indexPath.row].weight_type!
        cell.lblDiscount.text = "\(String(describing: arrOderListCategoryWise[indexPath.row].discount!))/-"
        
//        let imgUrl = arrOderListCategoryWise[indexPath.row].category_image!
//        cell.imgProduct.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: ""))
        cell.imgProduct.cornerRadius = cell.imgProduct.frame.size.width/2
        cell.lblPlusMinus.text = "\(String(describing: self.arrOderListCategoryWise[indexPath.row].selectedQty ?? 0))"
        
        // check whether add or not
        cell.viewAddBtn.isHidden = arrOderListCategoryWise[indexPath.row].isSelected == true ?  true : false
        cell.viewAddItem.isHidden = arrOderListCategoryWise[indexPath.row].isSelected == true ?  false : true
        
        // set tags
        cell.btnAdd.tag = indexPath.row
        cell.btnPlus.tag = indexPath.row
        cell.btnMinus.tag = indexPath.row
        cell.btnProductDetail.tag = indexPath.row
        cell.btnBuyNow.tag = indexPath.row
        
        // set actions
        cell.btnAdd.addTarget(self, action: #selector(add(sender:)), for: .touchUpInside)
        cell.btnPlus.addTarget(self, action: #selector(plus(sender:)), for: .touchUpInside)
        cell.btnMinus.addTarget(self, action: #selector(minus(sender:)), for: .touchUpInside)
        cell.btnProductDetail.addTarget(self, action: #selector(btnProductdetailAction(sender:)), for: .touchUpInside)
        cell.btnBuyNow.addTarget(self, action: #selector(btnBuyNow(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

//MARK:- FILTER DATA BACK DELEGATE METHOD
@available(iOS 13.0, *)
extension SelectListVC:FilteredDataShow {
    
    func filterResult(data: [ListCategoryStruct2]) {
        print("DELEGATE CALLED")
        self.arrOderListCategoryWise = data
        self.tblView.reloadData()
    }
}
