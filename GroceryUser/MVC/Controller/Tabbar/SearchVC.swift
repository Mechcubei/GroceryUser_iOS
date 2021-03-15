//
//  SearchVC.swift
//  GroceryUser
//
//  Created by osx on 22/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SearchVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var txtSearch: UITextField!
    
    
    //MARK:- LOCAL VARIABLE
    var arrSearchProduct = [ListCategoryStruct2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  self.searchProduct()
        self.registerNibFileName()
        self.txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        self.txtSearch.becomeFirstResponder()

    }
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        tblView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    //MARK:- SEARCH PRODUCT API
    func searchProduct(searchString:String) {
        
        let params:[String:String] = ["full_search":searchString]
        GetApiResponse.shared.searchProduct(params: params) { (data:ListCategoryStruct) in
            print(data)
            self.arrSearchProduct = data.data!
            self.tblView.reloadData()
        }
    }
    
    //MARK:- SEARCH PRODUCT API
    func searchProductABC() {
        
        let params:[String:String] = [:]
        GetApiResponse.shared.searchProduct(params: params) { (data:ListCategoryStruct) in
            print(data)
            self.arrSearchProduct = data.data!
            self.tblView.reloadData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.searchProduct(searchString: txtSearch.text!)
    }
    
    //MARK:- ACTION BUTTON
    @IBAction func btnClear(_ sender: Any) {
        self.txtSearch.text = ""
        self.arrSearchProduct.removeAll()
        self.tblView.reloadData()
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:- EXTENTION TABLEVIEW
@available(iOS 13.0, *)
extension SearchVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearchProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        
        cell.lblInventoryName.text = arrSearchProduct[indexPath.row].inventory_name
        cell.lblCategoryName.text = arrSearchProduct[indexPath.row].category_name
        cell.lblPrice.text = "MRP Rs. \(String(describing: arrSearchProduct[indexPath.row].price!))"
        let imgUrl = arrSearchProduct[indexPath.row].image
        cell.imgProduct.sd_setImage(with: URL(string: imgUrl ?? ""), placeholderImage: UIImage(named: ""))
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}
