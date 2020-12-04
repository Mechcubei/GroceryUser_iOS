//
//  DeliveryOptionVC.swift
//  GroceryUser
//
//  Created by osx on 28/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class DeliveryOptionVC: UIViewController {
    
    //MARK:- LOCAL VARIABLES
    var arrProduct = [ListCategoryStruct2]()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(arrProduct)
 
    }
    //MARK:- ORDER REQUEST API
    func orderRequest() {
  
        var subProductArr = [[String:Any]]()
        for i in 0..<arrProduct.count {
            let data:[String:Any] =
            [
                "quantity":arrProduct[i].qty!,
                "merchant_inventory_id": arrProduct[i].merchant_inventory_id!
            ]
            subProductArr.append(data)
            
            print(subProductArr)
        }
        
        let dataDict:[String:Any] = [
            "data":subProductArr
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject:dataDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        let params:[String:Any] = [
            
            "address":"Mohali Stadium Road Phase 3B-1 Sector 60 Sahibzada Ajit Singh Nagar Sahibzada Ajit Singh Nagar Punjab",
            "latitude":"30.7123702",
            "longitude":"76.7197032",
            "product":jsonString!]
        print(params)
        
        GetApiResponse.shared.order_request(params: params) { (data: OrderRequestStruct) in
            print(data)
            if data.statusCode == 200 {
                let dashboardVC = self.navigationController!.viewControllers.filter { $0 is CategoriesVC }.first!
                self.navigationController!.popToViewController(dashboardVC, animated: true)
                Utilities.shared.showAlertWithOK(title: "", msg: data.message!)
            } else {
                Utilities.shared.showAlertWithOK(title: "", msg: data.message!)
            }
        }
    }
    
    //MARK:- ACTION BUTTON
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnProceedToPay(_ sender: Any) {
        self.orderRequest()
    }
    
}
