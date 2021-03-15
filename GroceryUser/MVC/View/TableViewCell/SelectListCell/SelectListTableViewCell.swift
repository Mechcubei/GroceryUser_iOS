//
//  SelectListTableViewCell.swift
//  GroceryUser
//
//  Created by osx on 27/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class SelectListTableViewCell: UITableViewCell {
    //MARK:- LOCAL VARIABLES
    var btnAddAction: (() -> Void)?
    var btnProductDetailTrigger: (() -> Void)?
    var btnPlusAction:(() -> Void)?
    var btnMinusAction:(() -> Void)?
    
    //MARK:- OUTLETS
    @IBOutlet var btnBuyNow: DesignableButton!
    @IBOutlet var viewAddBtn: UIView!
    @IBOutlet var viewAddItem: UIView!
    @IBOutlet var btnAdd: DesignableButton!
    @IBOutlet var btnProductDetail: UIButton!
    
    @IBOutlet var lblDiscount: UILabel!
    
    @IBOutlet var btnMinus: UIButton!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblProductInventoryName: UILabel!
    
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet var lblWeight: UILabel!
    @IBOutlet var lblPlusMinus: UILabel!
    @IBOutlet var viewMinusBtn: DesignableButton!
    @IBOutlet var viewPlusBtn: DesignableButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
            
    @IBAction func btnAdd(_ sender: UIButton) {
        self.btnAddAction?()
    }
            
    @IBAction func btnProductDetail(_ sender: Any) {
        self.btnProductDetailTrigger?()
    }
    @IBAction func btnMinus(_ sender: Any) {
        self.btnMinusAction?()
        
    }
    @IBAction func btnPlus(_ sender: Any) {
        self.btnPlusAction?()
    }
}
