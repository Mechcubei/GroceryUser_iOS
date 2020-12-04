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
    @IBOutlet var imgProduct: UIImageView!
    
    
    var btnProductDetailAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    @IBAction func btnProductDetail(_ sender: Any) {
        self.btnProductDetailAction?()
    }
    
}
