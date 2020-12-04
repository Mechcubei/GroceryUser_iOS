//
//  SelectListVC.swift
//  GroceryUser
//
//  Created by osx on 27/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SelectListVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    
    //MARK:- LOCAL VARIABLES
    var arrOderListCategoryWise = [ListCategoryStruct2]()
    var categoriesID:Int?
    var merchantInventoryIDSelected:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.orderListCategoryWise()
        
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.tblView.register(UINib(nibName: "SelectListTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectListTableViewCell")
    }
    //MARK:- ORDER LIST CATEGORY WISE API
    func orderListCategoryWise() {
    
        GetApiResponse.shared.orderListCategoryWise(params: "\(String(describing: categoriesID!))") { (data:ListCategoryStruct) in
            print(data)
            self.arrOderListCategoryWise = data.data!
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
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func add(sender:UIButton){
        
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == nil {
            self.arrOderListCategoryWise[sender.tag].selectedQty = 0
        }
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == self.arrOderListCategoryWise[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "", msg: "Stock out of Limit")
            return
        }
      
        self.arrOderListCategoryWise[sender.tag].isSelected = true
        self.tblView.reloadData()

    }
    
    @objc func plus(sender:UIButton){
        
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == nil {
            self.arrOderListCategoryWise[sender.tag].selectedQty = 0
        }
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == self.arrOderListCategoryWise[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "", msg: "Out of Limit")
            return
        }
        
        self.arrOderListCategoryWise[sender.tag].selectedQty! += 1
        self.tblView.reloadData()
    }
    
    @objc func minus(sender:UIButton){
        if  self.arrOderListCategoryWise[sender.tag].selectedQty == nil{
            self.arrOderListCategoryWise[sender.tag].selectedQty = 0
        }
        
        guard self.arrOderListCategoryWise[sender.tag].selectedQty!  > 0 else {
            self.arrOderListCategoryWise[sender.tag].isSelected = false
            self.tblView.reloadData()
            return
        }
        
        self.arrOderListCategoryWise[sender.tag].selectedQty! -= 1
        self.tblView.reloadData()
    }
    
    @objc func btnProductdetailAction(sender:UIButton) {
        
        let vc = ENUM_STORYBOARD<ProductDetailVC>.tabbar.instantiativeVC()
        vc.merchantInventoryID = self.arrOderListCategoryWise[sender.tag].merchant_inventory_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnAddBasket(_ sender: Any) {
        arrOderListCategoryWise = arrOderListCategoryWise.filter{ $0.isSelected == true }
        print(arrOderListCategoryWise)
        let vc = ENUM_STORYBOARD<BasketVC>.tabbar.instantiativeVC()
        vc.arrSelectedList = arrOderListCategoryWise
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
        cell.lblPrice.text = "MRP: RS " + "\(arrOderListCategoryWise[indexPath.row].price!)"
        cell.lblWeight.text = "Weight: " + arrOderListCategoryWise[indexPath.row].weight_type!
        cell.lblPlusMinus.text = "\(self.arrOderListCategoryWise[indexPath.row].selectedQty ?? 0)"
        
        // check whether add or not
        cell.viewAddBtn.isHidden = arrOderListCategoryWise[indexPath.row].isSelected == true ?  true : false
        cell.viewAddItem.isHidden = arrOderListCategoryWise[indexPath.row].isSelected == true ?  false : true
        
        // set tags
        cell.btnAdd.tag = indexPath.row
        cell.btnPlus.tag = indexPath.row
        cell.btnMinus.tag = indexPath.row
        cell.btnProductDetail.tag = indexPath.row
        
        // set actions
        cell.btnAdd.addTarget(self, action: #selector(add(sender:)), for: .touchUpInside)
        cell.btnPlus.addTarget(self, action: #selector(plus(sender:)), for: .touchUpInside)
        cell.btnMinus.addTarget(self, action: #selector(minus(sender:)), for: .touchUpInside)
        cell.btnProductDetail.addTarget(self, action: #selector(btnProductdetailAction(sender:)), for: .touchUpInside)
     
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}
