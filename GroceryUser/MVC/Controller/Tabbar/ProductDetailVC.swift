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
    @IBOutlet var aboutProductTblView: UITableView!
    @IBOutlet var ratingTblView: UITableView!
    @IBOutlet var aboutproductTableviewheight: NSLayoutConstraint!
    @IBOutlet var ratingTableviewHeight: NSLayoutConstraint!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblAddToBasket: UILabel!
    @IBOutlet var viewBtnAddToBasket: UIView!
    
    //MARK:- LOCAL VARIABLES
    var merchantInventoryID:Int?
    var arrProductDetail = [ListCategoryStruct2]()
    var arrProductView = [ProductViewStruct2]()
    var isCommingFrom:Bool = false
    var basketQuantity = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productView()
        self.SetAboutProductTblViewHeight()
        self.SetRatingTblViewHeight()
        self.registerNibFileName()
        self.productView()
        
        self.lblAddToBasket.text = self.isCommingFrom == true ? "ADD TO BASKET": "CHECK OUT"
        self.viewBtnAddToBasket.isHidden = self.basketQuantity != 0 ? true : false
        
    }
    
    //MARK:- PRODUCT VIEW API'S
    func productView() {
        
        let params:[String:Any] = ["merchant_inventory_id":merchantInventoryID!]
        GetApiResponse.shared.productView(params: params) { (data:ProductViewStruct) in
            print(data)

            self.arrProductView = data.data
            self.lblProductName.text = self.arrProductView[0].inventory_name
            self.lblPrice.text = "MRP: Rs.\(String(describing: self.arrProductView[0].price!))"
            self.lblDiscount.text = "\(String(describing: self.arrProductView[0].discount!))/-"
            let imgUrl = self.arrProductView[0].category_image
            self.imgProduct.sd_setImage(with: URL(string: imgUrl ?? ""), placeholderImage: UIImage(named: ""))
        }
    }
    
    //MARK:- ADD TO BASKET API
    func addToBasket(index:Int) {
        
        let params:[String:Any] = [
            "merchant_user_id":arrProductView[index].marchent_user_id!,
            "merchant_inventory_id":arrProductView[index].merchant_inventory_id!,
            "quantity":"1"
        ]
        print(params)
        Loader.shared.showLoader()
        GetApiResponse.shared.addToBasket(params: params) { (data:AddToBasketStruct) in
            print(data)
            Loader.shared.stopLoader()
            
            guard data.statusCode == 200 else {
                Utilities.shared.showAlertWithOK(title: "ALERT!", msg: data.message!)
                return
            }
            self.navigationController?.popViewController(animated: true)
            Utilities.shared.showAlert(title: "", msg: data.message!)
        }
    }
   
    //MARK:- REGISTER NIB FILE NAME
      func registerNibFileName() {

        self.aboutProductTblView.register(UINib(nibName: "AboutProductTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutProductTableViewCell")
        self.ratingTblView.register(UINib(nibName: "RatingReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingReviewTableViewCell")
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
    
    @IBAction func btnAddToBasket(_ sender: UIButton) {
        guard isCommingFrom == true else {
            print("CHECK OUT BUTTON TAPPED")
            let vc = ENUM_STORYBOARD<DeliveryOptionVC>.tabbar.instantiativeVC()
            vc.arrProduct = self.arrProductDetail
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.addToBasket(index: sender.tag)
    }
}

//MARK:- EXTENSTION TABLEVIEW
@available(iOS 13.0, *)
extension ProductDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if (tableView == self.aboutProductTblView) {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if (tableView == self.aboutProductTblView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutProductTableViewCell", for: indexPath) as! AboutProductTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingReviewTableViewCell", for: indexPath) as! RatingReviewTableViewCell
            return cell
        }
    }
}
