//
//  SelectMerchantCategoryVC.swift
//  GroceryUser
//
//  Created by osx on 03/11/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SelectMerchantCategoryVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet var collectnView: UICollectionView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var btnClear: UIButton!
    @IBOutlet var searchTblView: UITableView!
    @IBOutlet var viewHideTableview: UIView!
    @IBOutlet var lblNoDataFound: UILabel!
    
    //MARK:- LOCAL VARIABLES
    var merchantUserID:Int?
    var arrListCategory = [ListCategoryStruct2]()
    var arrSearchProduct = [ListCategoryStruct2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFileName()
        self.listCategory()
        self.tabBarController?.tabBar.isHidden = true
        self.txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.searchProduct(searchString: txtSearch.text!)
        self.searchTblView.reloadData()
    }
    
    
    
    //MARK:- REGISTER NIB FILE NAME
    func registerNibFileName() {
        self.collectnView.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        self.searchTblView.register(UINib(nibName: "SelectListTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectListTableViewCell")
        
    }
    //MARK:- LIST CATEGORY API
    func listCategory() {
        Loader.shared.showLoader()
        let params:[String:Any] = ["merchant_user_id":merchantUserID!]
        GetApiResponse.shared.listCategory(params: params) { (data:ListCategoryStruct) in
            print(data)
            Loader.shared.stopLoader()
            self.arrListCategory = data.data!
            self.collectnView.reloadData()
        }
    }
    
    //MARK:- SEARCH PRODUCT API
    func searchProduct(searchString:String) {
        
        let params:[String:String] = ["full_search":searchString,"merchant_user_id":"\(String(describing: merchantUserID!))"]
        print(params)
        GetApiResponse.shared.searchProduct(params: params) { (data:ListCategoryStruct) in
            print(data)
            
            guard data.statusCode == 200 else {
                self.lblNoDataFound.isHidden = false
                self.searchTblView.isHidden = true
                self.lblNoDataFound.text = data.message!
                return
            }
            self.arrSearchProduct = data.data!
            self.setBascketSelectedItems(array: self.arrSearchProduct.count)
            self.searchTblView.reloadData()
        }
    }
    
    //MARK:- DELETE BASKET API
    func deleteBasketList(index:Int) {
        
        let params:[String:Any] = [
            "basket_id":arrSearchProduct[index].basket_id!,
            "merchant_user_id":arrSearchProduct[index].marchent_user_id!
        ]
        
        GetApiResponse.shared.deleteBasketList(params: params) { (data:ListCategoryStruct) in
            print(data)
            
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            self.arrSearchProduct[index].isSelected = false
            self.searchTblView.reloadData()
        }
    }
    
    func setBascketSelectedItems(array:Int){
        for i in 0..<array {
            if let _ = self.arrSearchProduct[i].basket_qty{
                self.arrSearchProduct[i].isSelected  =  true
                self.arrSearchProduct[i].selectedQty = self.arrSearchProduct[i].basket_qty
            }
        }
    }
    
    //MARK:- ADD TO BASKET API
    func addToBasket(index:Int) {
        
        let params:[String:Any] = [
            "merchant_user_id":merchantUserID!,
            "merchant_inventory_id":arrSearchProduct[index].merchant_inventory_id!,
            "quantity":arrSearchProduct[index].selectedQty ?? 1
        ]
        print(params)
        GetApiResponse.shared.addToBasket(params: params) { (data:AddToBasketStruct) in
            print(data)
        }
    }
    
    //MARK:- ACTION ADD TO CART VALUE
    @objc func add(sender:UIButton){
        
        self.addToBasket(index: sender.tag)
        
        if  self.arrSearchProduct[sender.tag].selectedQty == nil {
            self.arrSearchProduct[sender.tag].selectedQty = 1
        }
        
        if  self.arrSearchProduct[sender.tag].selectedQty == self.arrSearchProduct[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "ALERT!", msg: "Stock out of Limit")
            return
        }
        
        self.arrSearchProduct[sender.tag].isSelected = true
        self.searchTblView.reloadData()
        
    }
    
    //MARK:- ACTION PLUS VALUE
    @objc func plus(sender:UIButton){
        
        if  self.arrSearchProduct[sender.tag].selectedQty == nil {
            self.arrSearchProduct[sender.tag].selectedQty = 1
        }
        if  self.arrSearchProduct[sender.tag].selectedQty == self.arrSearchProduct[sender.tag].qty {
            Utilities.shared.showAlertWithOK(title: "", msg: "Out of Limit")
            return
        }
        print("now count is", self.arrSearchProduct[sender.tag].selectedQty!)
        self.arrSearchProduct[sender.tag].selectedQty! += 1
        self.addToBasket(index: sender.tag)
        self.searchTblView.reloadData()
    }
    
    //MARK:- ACTION MINUS VALUE
    @objc func minus(sender:UIButton){
        
        if  self.arrSearchProduct[sender.tag].selectedQty == nil{
            self.arrSearchProduct[sender.tag].selectedQty = 1
        }
        
        guard self.arrSearchProduct[sender.tag].selectedQty!  > 1 else {
            self.arrSearchProduct[sender.tag].isSelected = false
            self.deleteBasketList(index: sender.tag)
            self.searchTblView.reloadData()
            return
        }
        print("now count is", self.arrSearchProduct[sender.tag].selectedQty!)
        self.arrSearchProduct[sender.tag].selectedQty! -= 1
        
        self.addToBasket(index: sender.tag)
        self.searchTblView.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard textField.text?.count != 0 else {
            self.arrSearchProduct.removeAll()
            self.searchTblView.isHidden = false
            self.lblNoDataFound.isHidden = true
            self.txtSearch.resignFirstResponder()
            self.searchTblView.reloadData()
            return
        }
        self.searchProduct(searchString: txtSearch.text!)
        self.searchTblView.isHidden = false
        self.lblNoDataFound.isHidden = true
        self.viewHideTableview.isHidden = false
        self.btnClear.isHidden = false
    }
    
    //MARK:- BUY NOW BUTTON ACTION
    @objc func btnBuyNow(sender:UIButton) {
        let vc = ENUM_STORYBOARD<BasketVC>.tabbar.instantiativeVC()
        vc.buyNow =  true
        vc.isCommingFromSelectList = true
        vc.arrSelectedList = [arrSearchProduct[sender.tag]]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
 
    //MARK:- ACTION BUTTONS
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddPhoto(_ sender: UIButton) {
        let vc = ENUM_STORYBOARD<UploadPhotoVC>.tabbar.instantiativeVC()
        vc.merchantUserID = merchantUserID!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnClear(_ sender: Any) {
        self.txtSearch.text = ""
        self.viewHideTableview.isHidden = true
        self.btnClear.isHidden = true
        self.arrSearchProduct.removeAll()
        self.searchTblView.reloadData()
        self.txtSearch.resignFirstResponder()
    }
    
    @IBAction func btnAddToCart(_ sender: Any) {
        let vc = ENUM_STORYBOARD<BasketVC>.tabbar.instantiativeVC()
        vc.isCommingFromSelectList = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
//MARK:- EXTENSION COLLECTION VIEW
@available(iOS 13.0, *)
extension SelectMerchantCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrListCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        let imageUrl = arrListCategory[indexPath.row].category_image
        cell.imgProduct.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: ""))
        cell.lblProductName.text = arrListCategory[indexPath.row].category_name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ENUM_STORYBOARD<SelectListVC>.tabbar.instantiativeVC()
        vc.categoriesID = arrListCategory[indexPath.row].category_id
        vc.merchantUserID = self.merchantUserID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK:- EXTENTION TABLE VIEW
@available(iOS 13.0, *)
extension SelectMerchantCategoryVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearchProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectListTableViewCell", for: indexPath) as! SelectListTableViewCell
       
        // set data
        cell.lblProductInventoryName.text = arrSearchProduct[indexPath.row].inventory_name
        cell.lblProductName.text = arrSearchProduct[indexPath.row].category_name
        cell.lblPrice.text = "\(arrSearchProduct[indexPath.row].price!)"
        cell.lblWeight.text = "Weight: " + arrSearchProduct[indexPath.row].weight_type!
        cell.lblDiscount.text = "\(String(describing: arrSearchProduct[indexPath.row].discount!))/-"
        
//        let imgUrl = arrSearchProduct[indexPath.row].image!
//        cell.imgProduct.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: ""))
        cell.imgProduct.cornerRadius = cell.imgProduct.frame.size.width/2
        cell.lblPlusMinus.text = "\(String(describing: self.arrSearchProduct[indexPath.row].selectedQty ?? 1))"
        
        // check whether add or not
        cell.viewAddBtn.isHidden = arrSearchProduct[indexPath.row].isSelected == true ?  true : false
        cell.viewAddItem.isHidden = arrSearchProduct[indexPath.row].isSelected == true ?  false : true
        
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
        cell.btnBuyNow.addTarget(self, action: #selector(btnBuyNow(sender:)), for: .touchUpInside)
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}
