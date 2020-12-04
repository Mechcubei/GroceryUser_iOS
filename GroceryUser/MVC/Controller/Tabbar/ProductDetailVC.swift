//
//  ProductDetailVC.swift
//  GroceryUser
//
//  Created by osx on 28/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
class ProductDetailVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var packSizeTblView: UITableView!
    @IBOutlet var aboutProductTblView: UITableView!
    @IBOutlet var ratingTblView: UITableView!
    @IBOutlet var packSizeTableviewHeight: NSLayoutConstraint!
    @IBOutlet var aboutproductTableviewheight: NSLayoutConstraint!
    @IBOutlet var ratingTableviewHeight: NSLayoutConstraint!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var imgProduct: UIImageView!
    
    //MARK:- LOCAL VARIABLES
    var merchantInventoryID:Int?
    var arrProductView = [ProductViewStruct2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productView()
        self.SetPackSizeTblViewHeight()
        self.SetAboutProductTblViewHeight()
        self.SetRatingTblViewHeight()
        self.registerNibFileName()
        
        
    }
  
    //MARK:- PRODUCT VIEW API'S
    func productView() {
        
        let params:[String:Any] = ["merchant_inventory_id":merchantInventoryID!]
        GetApiResponse.shared.productView(params: params) { (data:ProductViewStruct) in
            print(data)
            
            self.arrProductView = data.data
            self.lblProductName.text = self.arrProductView[0].inventory_name
            self.lblPrice.text = "\(String(describing: self.arrProductView[0].price!))"
            let imgUrl = self.arrProductView[0].category_image
            self.imgProduct.sd_setImage(with: URL(string: imgUrl ?? ""), placeholderImage: UIImage(named: ""))
            
        }
    }
    
    
    
    //MARK:- REGISTER NIB FILE NAME
      func registerNibFileName() {
          
        self.packSizeTblView.register(UINib(nibName: "PackSizeTableViewCell", bundle: nil), forCellReuseIdentifier: "PackSizeTableViewCell")
        self.aboutProductTblView.register(UINib(nibName: "AboutProductTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutProductTableViewCell")
        self.ratingTblView.register(UINib(nibName: "RatingReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingReviewTableViewCell")
      }
    
    //SET PACK SIZE HEIGHT DYNAMICALLY
     func SetPackSizeTblViewHeight() {
         DispatchQueue.main.async{
             self.packSizeTblView.reloadData()
             self.view.layoutIfNeeded()
             self.packSizeTableviewHeight.constant = self.packSizeTblView.contentSize.height
             self.view.layoutIfNeeded()
         }
     }
    
    //SET ABOUT PRODUCT HEIGHT DYNAMICALLY
     func SetAboutProductTblViewHeight() {
         DispatchQueue.main.async{
             self.aboutProductTblView.reloadData()
             self.view.layoutIfNeeded()
             self.aboutproductTableviewheight.constant = self.aboutProductTblView.contentSize.height
             self.view.layoutIfNeeded()
         }
     }
    
    //SET RATING & REVIEW HEIGHT DYNAMICALLY
     func SetRatingTblViewHeight() {
         DispatchQueue.main.async{
             self.ratingTblView.reloadData()
             self.view.layoutIfNeeded()
             self.ratingTableviewHeight.constant = self.ratingTblView.contentSize.height
             self.view.layoutIfNeeded()
         }
     }
    //MARK:- ACTION BUTTON
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- EXTENSTION TABLEVIEW
@available(iOS 13.0, *)
extension ProductDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.packSizeTblView){
            return 4
        } else if (tableView == self.aboutProductTblView) {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.packSizeTblView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PackSizeTableViewCell", for: indexPath) as! PackSizeTableViewCell
            return cell
        } else if (tableView == self.aboutProductTblView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutProductTableViewCell", for: indexPath) as! AboutProductTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingReviewTableViewCell", for: indexPath) as! RatingReviewTableViewCell
            return cell
        }
    }
}
