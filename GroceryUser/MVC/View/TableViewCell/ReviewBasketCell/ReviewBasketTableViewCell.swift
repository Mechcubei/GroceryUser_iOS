//
//  ReviewBasketTableViewCell.swift
//  GroceryUser
//
//  Created by osx on 27/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class ReviewBasketTableViewCell: UITableViewCell {

    //MARK:-OUTLETS
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblWeightType: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblValueIncrimentAndDecrement: UILabel!
    @IBOutlet var btnMinus: UIButton!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var viewPlusMinus: UIView!
    @IBOutlet var btnBuyNow: DesignableButton!
    @IBOutlet var btnProductDetail: UIButton!
    
    //MARK:- LOCAL VARIABLES
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
        
    }
   
}
