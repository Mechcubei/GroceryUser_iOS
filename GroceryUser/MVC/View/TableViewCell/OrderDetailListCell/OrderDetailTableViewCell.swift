//
//  OrderDetailTableViewCell.swift
//  GroceryUser
//
//  Created by osx on 05/01/21.
//  Copyright © 2021 osx. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblQty: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        
    }
    
}
