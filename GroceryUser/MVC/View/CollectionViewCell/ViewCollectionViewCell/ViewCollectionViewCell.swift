//
//  ViewCollectionViewCell.swift
//  GroceryUser
//
//  Created by osx on 22/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class ViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblCategoryName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnAdd: DesignableButton!
    @IBOutlet var lblAddMinusValue: UILabel!
    @IBOutlet var btnMinus: UIButton!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var viewAddBtn: UIView!
    @IBOutlet var viewAddItems: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
