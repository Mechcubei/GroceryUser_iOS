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
    
    //MARK:- LOCAL VARIABLES
    var arrSelectedList = [ListCategoryStruct2]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        print(arrSelectedList)
        
    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        
        self.tblView.register(UINib(nibName: "ReviewBasketTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewBasketTableViewCell")
        
    }
    
    @IBAction func btnCheckOut(_ sender: Any) {
        let vc = ENUM_STORYBOARD<DeliveryOptionVC>.tabbar.instantiativeVC()
        vc.arrProduct = arrSelectedList
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        cell.lblProductName.text = arrSelectedList[indexPath.row].inventory_name
        cell.lblPrice.text = "Rs. \(String(describing: arrSelectedList[indexPath.row].price!))"
        cell.lblWeightType.text = arrSelectedList[indexPath.row].weight_type
        cell.btnProductDetailAction = {
            let vc = ENUM_STORYBOARD<ProductDetailVC>.tabbar.instantiativeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
